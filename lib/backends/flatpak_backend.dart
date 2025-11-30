import '../core/application.dart';
import '../core/flatpak_application.dart';
import '../core/logger.dart';
import 'backend.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:libflatpak/libflatpak.dart';
import 'package:xml/xml.dart';

class FlatpakBackend implements Backend {
  @override
  late String arch;

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
  Map<String, Application> getInstalledPackages() {
    final FlatpakBindings bindings =
        FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so'));
    ffi.Pointer<FlatpakInstallation> installationPtr = getFlatpakInstallation();
    ffi.Pointer<ffi.Pointer<GError>> error =
        pkg_ffi.calloc<ffi.Pointer<GError>>();
    Map<String, Application> apps = {};
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

        final ffi.Pointer<FlatpakInstalledRef> refPtr =
            refVoidPtr.cast<FlatpakInstalledRef>();

        final ffi.Pointer<ffi.Char> dirPtr =
            bindings.flatpak_installed_ref_get_deploy_dir(refPtr);
        final deployDir = dirPtr.cast<pkg_ffi.Utf8>().toDartString();

        final ffi.Pointer<GBytes> refAppPtr =
            bindings.flatpak_installed_ref_load_appdata(
          refPtr,
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
              throw XmlParserException(
                  "Error: Could not find the main <component> tag.");
            }
            final app = appFromXML(componentElement, deployDir, true, null);
            apps[app.id] = app;
          } on XmlParserException catch (e) {
            logger.e('Error parsing XML: $e');
          }
          pkg_ffi.malloc.free(sizeP);
        } else {
          logger.w(
              'Failed to load appdata. GError pointer received: ${error.value}');
          error.value = ffi.nullptr;
          final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr[i];
          final ffi.Pointer<FlatpakRef> refPtr = refVoidPtr.cast<FlatpakRef>();
          final ffi.Pointer<ffi.Char> namePtr =
              bindings.flatpak_ref_get_name(refPtr);
          final String id = namePtr.cast<pkg_ffi.Utf8>().toDartString();
          apps[id] = FlatpakApplication(
            id: id,
            installed: true,
          );
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

  Application appFromXML(XmlElement componentElement, String deployDir,
      bool installed, String? remote) {
    final id = componentElement.findElements('id').firstOrNull?.innerText;
    if (id == null) {
      throw XmlParserException("Error: Could not find <id> tag.");
    }

    String? name;
    for (var nameElement in componentElement.findAllElements('name').where(
      (element) {
        return element.parentElement?.name.local != 'developer';
      },
    )) {
      if (nameElement.getAttribute('xml:lang') == null) {
        name = nameElement.innerText;
      }
    }

    String? summary;
    for (var summaryElement in componentElement.findAllElements('summary')) {
      if (summaryElement.getAttribute('xml:lang') == null) {
        summary = summaryElement.innerText;
      }
    }

    final license =
        componentElement.findElements('project_license').firstOrNull?.innerText;

    String? description;
    for (final child in componentElement.children) {
      if (child is XmlElement &&
          child.name.local == 'description' &&
          child.getAttribute('xml:lang') == null) {
        description = child.innerText;
        break;
      }
    }

    String? developer;
    for (var devElement in componentElement.findAllElements('name').where(
      (element) {
        return element.parentElement?.name.local == 'developer';
      },
    )) {
      if (devElement.getAttribute('xml:lang') == null) {
        developer = devElement.innerText;
      }
    }

    String? icon;
    String? remoteIcon;
    int iconHeight = 0;
    int remoteIconHeight = 0;
    for (var iconXML in componentElement.findAllElements('icon')) {
      String? heightAttr = iconXML.getAttribute('height');
      int height = (heightAttr != null) ? int.parse(heightAttr) : 0;
      if (iconXML.getAttribute('type') == 'cached' && height > iconHeight) {
        icon = (deployDir.startsWith("/var/lib/flatpak/appstream"))
            ? "$deployDir/icons/${height}x$height/${iconXML.innerText}"
            : "$deployDir/files/share/app-info/icons/flatpak/${height}x$height/${iconXML.innerText}";
        iconHeight = height;
      } else if (iconXML.getAttribute('type') == 'remote' &&
          height > remoteIconHeight) {
        remoteIcon = iconXML.innerText;
        remoteIconHeight = height;
      }
    }
    if (icon != null) {
      File file = File(icon);
      if (!file.existsSync()) {
        icon = null;
      }
    }

    String? homepage;
    String? help;
    String? translate;
    String? vcs;
    for (var url in componentElement.findAllElements('url')) {
      final type = url.getAttribute('type');
      final text = url.innerText;
      switch (type) {
        case 'homepage':
          homepage = text;
        case 'help':
          help = text;
        case 'translate':
          translate = text;
        case 'vcs-browser':
          vcs = text;
      }
    }

    List<String> categories = [];
    var categoriesParent =
        componentElement.findElements('categories').firstOrNull;
    if (categoriesParent != null) {
      for (var category in categoriesParent.findElements('category')) {
        categories.add(category.innerText);
      }
    }

    List<Screenshot> screenshots = [];
    var screenshotsParent =
        componentElement.findElements('screenshots').firstOrNull;
    if (screenshotsParent != null) {
      for (var screenshot in screenshotsParent.findElements('screenshot')) {
        String? caption;
        String? thumb;
        String? full;
        int min = 1000000;
        int max = 0;
        if (screenshot.findElements('caption').isNotEmpty) {
          caption = screenshot.findElements('caption').first.innerText;
        }
        for (var image in screenshot.findElements('image')) {
          String? heightAttr = image.getAttribute('height');
          int height = (heightAttr != null) ? int.parse(heightAttr) : 0;
          if (height < min) {
            thumb = image.innerText;
            min = height;
          }
          if (height > max) {
            full = image.innerText;
            max = height;
          }
        }
        screenshots.add(Screenshot(
          caption: caption,
          thumb: thumb!,
          full: full ?? thumb,
        ));
      }
    }

    List<String> keywords = [];
    var keywordsParent = componentElement.findElements('keywords').firstOrNull;
    if (keywordsParent != null) {
      for (var keyword in keywordsParent.findElements('keyword')) {
        keywords.add(keyword.innerText);
      }
    }

    List<Release> releases = [];
    final releasesParent =
        componentElement.findAllElements('releases').firstOrNull;
    if (releasesParent != null) {
      for (final release in releasesParent.findElements('release')) {
        final version = release.getAttribute('version');
        final type = release.getAttribute('type');
        final timestamp = release.getAttribute('timestamp');
        final description =
            release.findAllElements('description').firstOrNull?.innerText;

        if (version != null && type != null && timestamp != null) {
          releases.add(Release(
            version: version,
            type: type,
            timestamp: timestamp,
            description: description,
          ));
        } else {
          logger.w('  -> WARNING: Skipping malformed release tag.');
        }
      }
    }

    final Map<String, String> content = {};
    final contentRatingElement =
        componentElement.findAllElements('content_rating').firstOrNull;

    if (contentRatingElement != null) {
      final attributeElements =
          contentRatingElement.findAllElements('content_attribute');

      for (final attribute in attributeElements) {
        final id = attribute.getAttribute('id');
        final value = attribute.innerText;

        if (id != null) {
          content[id] = value;
        } else {
          logger.w(
              '  -> WARNING: Skipping content_attribute tag with missing id.');
        }
      }
    }

    bool verified = false;
    final customParent = componentElement.findAllElements('custom').firstOrNull;
    if (customParent != null) {
      for (var value in customParent.findElements('value')) {
        if (value.getAttribute('key') == 'flathub::verification::verified') {
          verified = bool.parse(value.innerText);
        }
      }
    }

    String? type;
    String? runtime;
    String? sdk;
    String? bundle;
    final bundleParent = componentElement.findAllElements('bundle').firstOrNull;
    if (bundleParent != null) {
      type = bundleParent.getAttribute('type');
      runtime = bundleParent.getAttribute('runtime');
      sdk = bundleParent.getAttribute('sdk');
      bundle = bundleParent.innerText;
    }

    return FlatpakApplication(
      id: id,
      name: name,
      summary: summary,
      license: license,
      description: description,
      developer: developer,
      icon: icon ?? remoteIcon,
      homepage: homepage,
      help: help,
      translate: translate,
      vcs: vcs,
      categories: categories,
      screenshots: screenshots,
      keywords: keywords,
      releases: releases,
      content: content,
      verified: verified,
      installed: installed,
      type: type,
      runtime: runtime,
      sdk: sdk,
      bundle: bundle,
      remote: remote,
    );
  }

  @override
  Map<String, Application> getAllRemotePackages() {
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
      arch = archPtr.cast<pkg_ffi.Utf8>().toDartString();

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

            try {
              final XmlDocument document =
                  XmlDocument.parse(appstreamXmlContent);
              for (var componentElement
                  in document.findAllElements('component')) {
                Application app = appFromXML(
                    componentElement, appstreamDir, false, remoteName);
                apps[app.id] = app;
              }
            } on XmlParserException catch (e) {
              logger.w('Error parsing XML: $e');
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
}
