import 'dart:convert';
import 'dart:core';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:libflatpak/libflatpak.dart';
import 'package:outlet/appstream.dart/lib/appstream.dart';
import 'package:outlet/backends/backend.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/core/flatpak_application.dart';
import 'package:outlet/core/logger.dart';
import 'package:xml/xml.dart';

class FlatpakBackend implements Backend {
  ffi.Pointer<FlatpakInstallation> getFlatpakInstallation() {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();
    late ffi.Pointer<FlatpakInstallation> installationPtr;

    installationPtr =
        bindings.flatpak_installation_new_system(ffi.nullptr, error);

    if (installationPtr == ffi.nullptr) {
      if (error.value != ffi.nullptr) {
        logger.e(
            'Failed to get FlatpakInstallation. GError pointer received: ${error.value}');
      } else {
        logger.e(
            'Failed to get FlatpakInstallation, but no explicit GError was returned.');
      }
    } else {
      error.value = ffi.nullptr;
      logger.i(
          'Successfully created FlatpakInstallation object at address: $installationPtr');
    }
    return installationPtr;
  }

  @override
  List<String> getInstalledPackages() {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();
    List<String> apps = [];
    final ffi.Pointer<GPtrArray> installedRefsPtr =
        bindings.flatpak_installation_list_installed_refs(
            installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      error.value = ffi.nullptr;
      final GPtrArray installedRefs = installedRefsPtr.ref;
      final int length = installedRefs.len;
      logger.i('Found $length installed references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = installedRefs.pdata;

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr[i];

        final ffi.Pointer<FlatpakInstalledRef> installedRefPtr =
            refVoidPtr.cast<FlatpakInstalledRef>();

        final ffi.Pointer<GBytes> refAppPtr =
            bindings.flatpak_installed_ref_load_appdata(
          installedRefPtr,
          ffi.nullptr,
          error,
        );
        if (error.value == ffi.nullptr) {
          final int refAppSize = bindings.g_bytes_get_size(refAppPtr);
          final sizeP = pkg_ffi.malloc<gsize>();
          sizeP.value = refAppSize;
          final gconstpointer dataPtr =
              bindings.g_bytes_get_data(refAppPtr, sizeP);
          final ffi.Pointer<ffi.Void> voidPtr = dataPtr;
          final Uint8List compressedBytes =
              voidPtr.cast<ffi.Uint8>().asTypedList(sizeP.value);
          final GZipCodec gzipCodec = GZipCodec();
          final List<int> decompressedBytes = gzipCodec.decode(compressedBytes);
          final String xmlString = utf8.decode(decompressedBytes);
          try {
            final XmlDocument document = XmlDocument.parse(xmlString);
            final XmlElement? componentElement =
                document.findAllElements('component').firstOrNull;
            if (componentElement == null) {
              logger.i("Error: Could not find the main <component> tag.");
              continue;
            }
            final id =
                componentElement.findElements('id').firstOrNull?.innerText;
            if (id == null) {
              logger.i("Could not read component id of InstalledRef.");
              continue;
            }

            apps.add(id);
          } on XmlParserException catch (e) {
            logger.e('Error parsing XML: $e');
          }
          pkg_ffi.malloc.free(sizeP);
        } else {
          logger.w(
              'Failed to load appdata. GError pointer received: ${error.value}');
          error.value = ffi.nullptr;
        }
      }
      pkg_ffi.calloc.free(pdataPtr);
    } else {
      logger.e(
          'Failed to load installed flatpaks. GError pointer received: ${error.value}');
      pkg_ffi.calloc.free(error);
    }
    return apps;
  }

  @override
  Future<Map<String, Application>> getAllRemotePackages() async {
    await Future.microtask(() {});
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();
    Map<String, Application> apps = {};
    ffi.Pointer<GPtrArray> remotesPtr = bindings
        .flatpak_installation_list_remotes(installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      String? appstreamXmlContent;
      final GPtrArray remotesRefs = remotesPtr.ref;
      final int length = remotesRefs.len;
      logger.i('Found $length remote references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = remotesRefs.pdata;
      final ffi.Pointer<ffi.Char> archPtr = bindings.flatpak_get_default_arch();

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr[i];
        final ffi.Pointer<FlatpakRemote> remotePtr =
            refVoidPtr.cast<FlatpakRemote>();
        final ffi.Pointer<ffi.Char> remoteNamePtr =
            bindings.flatpak_remote_get_name(remotePtr);
        final String remoteName =
            remoteNamePtr.cast<pkg_ffi.Utf8>().toDartString();
        final ffi.Pointer<GFile> appstreamDirPtr =
            bindings.flatpak_remote_get_appstream_dir(remotePtr, archPtr);
        final ffi.Pointer<ffi.Char> appstreamDirCharPtr =
            bindings.g_file_get_path(appstreamDirPtr);
        final String appstreamDir =
            appstreamDirCharPtr.cast<pkg_ffi.Utf8>().toDartString();
        final ffi.Pointer<ffi.Char> appstreamFileNamePtr =
            'appstream.xml'.toNativeUtf8().cast();
        final ffi.Pointer<GFile> appstreamFilePtr =
            bindings.g_file_get_child(appstreamDirPtr, appstreamFileNamePtr);

        ffi.Pointer<ffi.Char>? fileContentsPtr;
        ffi.Pointer<ffi.Pointer<ffi.Char>> fileContentsPtrPtr =
            pkg_ffi.calloc<ffi.Pointer<ffi.Char>>();
        ffi.Pointer<ffi.Pointer<ffi.Char>> etagPtrPtr =
            pkg_ffi.calloc<ffi.Pointer<ffi.Char>>();
        ffi.Pointer<gsize>? sizeP;
        sizeP = pkg_ffi.calloc<gsize>();
        final int success = bindings.g_file_load_contents(appstreamFilePtr,
            ffi.nullptr, fileContentsPtrPtr, sizeP, etagPtrPtr, error);
        if (error.value == ffi.nullptr && success == 1) {
          fileContentsPtr = fileContentsPtrPtr.value;

          final int size = sizeP.value;

          if (size > 0) {
            final ffi.Pointer<ffi.Uint8> uint8Ptr = fileContentsPtr.cast();
            final Uint8List metaDataBytes = uint8Ptr.asTypedList(size);

            appstreamXmlContent =
                utf8.decode(metaDataBytes, allowMalformed: true);

            var collection = AppstreamCollection.fromXml(appstreamXmlContent);

            for (var component in collection.components) {
              apps[component.id] = FlatpakApplication(
                id: component.id,
                package: component.package,
                name: component.name,
                summary: component.summary,
                description: component.description,
                developerName: component.developerName,
                projectLicense: component.projectLicense,
                projectGroup: component.projectGroup,
                icons: component.icons,
                urls: component.urls,
                categories: component.categories,
                screenshots: component.screenshots,
                keywords: component.keywords,
                compulsoryForDesktops: component.compulsoryForDesktops,
                releases: component.releases,
                provides: component.provides,
                contentRatings: component.contentRatings,
                custom: component.custom,
                installed: false,
                bundles: component.bundles,
                remote: remoteName,
                type: component.type,
                deployDir: appstreamDir,
              );
            }
          }
        } else {
          logger.e("Error occurred.");
          error.value = ffi.nullptr;
        }
      }
    } else {
      logger.e("Error getting flatpak remotes: ${error.value}");
      error.value = ffi.nullptr;
    }
    return apps;
  }

  @override
  Future<bool> installApplication(String id, String remote) async {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();

    ffi.Pointer<FlatpakTransaction> transactionPtr =
        bindings.flatpak_transaction_new_for_installation(
            installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      ffi.Pointer<pkg_ffi.Utf8> remoteUtf8Ptr = remote.toNativeUtf8();
      ffi.Pointer<ffi.Char> remotePtr = remoteUtf8Ptr.cast<ffi.Char>();
      ffi.Pointer<pkg_ffi.Utf8> refUtf8Ptr = id.toNativeUtf8();
      ffi.Pointer<ffi.Char> refPtr = refUtf8Ptr.cast<ffi.Char>();
      bindings.flatpak_transaction_add_install(
          transactionPtr, remotePtr, refPtr, ffi.nullptr, error);

      if (error.value == ffi.nullptr) {
        bindings.flatpak_transaction_run(transactionPtr, ffi.nullptr, error);

        return true;
      } else {
        final ffi.Pointer<GError> errorPtr = error.value;
        final GError errorStruct = errorPtr.ref;
        final ffi.Pointer<ffi.Char> messagePtr = errorStruct.message;
        final String message = messagePtr.cast<pkg_ffi.Utf8>().toDartString();
        logger.e(
            'Failed to add install to FlatpakTransaction. GError pointer received: $message');
        error.value = ffi.nullptr;
      }
    } else {
      logger.e(
          'Failed to create FlatpakTransaction. GError pointer received: ${error.value}');
      error.value = ffi.nullptr;
    }
    return false;
  }

  @override
  Future<bool> uninstallApplication(String id) async {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();

    ffi.Pointer<FlatpakTransaction> transactionPtr =
        bindings.flatpak_transaction_new_for_installation(
            installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      ffi.Pointer<pkg_ffi.Utf8> refUtf8Ptr = id.toNativeUtf8();
      ffi.Pointer<ffi.Char> refPtr = refUtf8Ptr.cast<ffi.Char>();
      bindings.flatpak_transaction_add_uninstall(transactionPtr, refPtr, error);

      if (error.value == ffi.nullptr) {
        bindings.flatpak_transaction_run(transactionPtr, ffi.nullptr, error);

        if (error.value == ffi.nullptr) {
          logger.i("Successfully uninstalled $id");
          return true;
        }
      } else {
        final ffi.Pointer<GError> errorPtr = error.value;
        final GError errorStruct = errorPtr.ref;
        final ffi.Pointer<ffi.Char> messagePtr = errorStruct.message;
        final String message = messagePtr.cast<pkg_ffi.Utf8>().toDartString();
        logger.e(
            'Failed to add uninstall to FlatpakTransaction. GError pointer received: $message');
        error.value = ffi.nullptr;
      }
    } else {
      logger.e(
          'Failed to create FlatpakTransaction. GError pointer received: ${error.value}');
      error.value = ffi.nullptr;
    }
    return false;
  }

  @override
  Future<bool> updateApplication(String id) async {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();

    ffi.Pointer<FlatpakTransaction> transactionPtr =
        bindings.flatpak_transaction_new_for_installation(
            installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      ffi.Pointer<pkg_ffi.Utf8> refUtf8Ptr = id.toNativeUtf8();
      ffi.Pointer<ffi.Char> refPtr = refUtf8Ptr.cast<ffi.Char>();
      bindings.flatpak_transaction_add_update(
          transactionPtr, refPtr, ffi.nullptr, ffi.nullptr, error);

      if (error.value == ffi.nullptr) {
        bindings.flatpak_transaction_run(transactionPtr, ffi.nullptr, error);

        return true;
      } else {
        final ffi.Pointer<GError> errorPtr = error.value;
        final GError errorStruct = errorPtr.ref;
        final ffi.Pointer<ffi.Char> messagePtr = errorStruct.message;
        final String message = messagePtr.cast<pkg_ffi.Utf8>().toDartString();
        logger.e(
            'Failed to add update to FlatpakTransaction. GError pointer received: $message');
        error.value = ffi.nullptr;
      }
    } else {
      logger.e(
          'Failed to create FlatpakTransaction. GError pointer received: ${error.value}');
      error.value = ffi.nullptr;
    }
    return false;
  }
}
