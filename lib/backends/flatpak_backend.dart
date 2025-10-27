import 'dart:ffi' as ffi;
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:libflatpak/libflatpak.dart';
import 'package:xml/xml.dart';
import 'backend.dart';
import '../core/application.dart';
import '../core/flatpak_application.dart';

class FlatpakBackend implements Backend {
  late FlatpakBindings bindings;
  late ffi.Pointer<ffi.Pointer<GError>> error;
  late ffi.Pointer<FlatpakInstallation> installationPtr;

  FlatpakBackend()
      : bindings = FlatpakBindings(ffi.DynamicLibrary.open('libflatpak.so')),
        error = pkg_ffi.calloc<ffi.Pointer<GError>>() {
    this.installationPtr =
        this.bindings.flatpak_installation_new_system(ffi.nullptr, this.error);

    if (this.installationPtr == ffi.nullptr) {
      if (this.error.value != ffi.nullptr) {
        print(
            'Failed to get FlatpakInstallation. GError pointer received: ${this.error.value}');
      } else {
        print(
            'Failed to get FlatpakInstallation, but no explicit GError was returned.');
      }
    } else {
      print(
          'Successfully created FlatpakInstallation object at address: ${this.installationPtr}');
    }
    error.value = ffi.nullptr;
  }

  List<Application> getInstalledPackages() {
    List<Application> apps = [];
    final ffi.Pointer<GPtrArray> installed_refs =
        bindings.flatpak_installation_list_installed_refs(
            installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      error.value = ffi.nullptr;
      final GPtrArray installedRefs = installed_refs.ref;
      final int length = installedRefs.len;
      print('Found $length installed references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = installedRefs.pdata;

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;

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
          final ffi.Pointer<ffi.Void> void_ptr = dataPtr;
          final Uint8List compressedBytes =
              void_ptr.cast<ffi.Uint8>().asTypedList(sizeP.value);
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
            apps.add(appFromXML(componentElement, deployDir));
          } on XmlParserException catch (e) {
            print('Error parsing XML: $e');
          }
        } else {
          print(
              'Failed to load appdata. GError pointer received: ${this.error.value}');
          error.value = ffi.nullptr;
          final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;
          final ffi.Pointer<FlatpakRef> refPtr = refVoidPtr.cast<FlatpakRef>();
          final ffi.Pointer<ffi.Char> namePtr =
              bindings.flatpak_ref_get_name(refPtr);
          final String id = namePtr.cast<pkg_ffi.Utf8>().toDartString();
          apps.add(new FlatpakApplication(
            id: id,
          ));
        }
      }
      pkg_ffi.calloc.free(pdataPtr);
    } else {
      print(
          'Failed to load installed flatpaks. GError pointer received: ${this.error.value}');
      pkg_ffi.calloc.free(error);
    }
    return apps;
  }

  Application appFromXML(XmlElement componentElement, String? deployDir) {
    final id = componentElement.findElements('id').firstOrNull?.text.trim();
    if (id == null) {
      throw XmlParserException("Error: Could not find <id> tag.");
    }

    final name = componentElement.findElements('name').firstOrNull?.text.trim();
    final summary =
        componentElement.findElements('summary').firstOrNull?.text.trim();
    final license = componentElement
        .findElements('project_license')
        .firstOrNull
        ?.text
        .trim();
    final description =
        componentElement.findElements('description').firstOrNull?.text.trim();
    final developer =
        componentElement.findElements('developer').firstOrNull?.text.trim();

    String? icon = null;
    String? remoteIcon = null;
    int iconHeight = 0;
    int remoteIconHeight = 0;
    for (var iconXML in componentElement.findAllElements('icon')) {
      String? heightAttr = iconXML.getAttribute('height');
      int height = (heightAttr != null) ? int.parse(heightAttr) : 0;
      if (iconXML.getAttribute('type') == 'cached' &&
          height > iconHeight &&
          deployDir != null) {
        icon =
            "${deployDir}/files/share/app-info/icons/flatpak/${height}x${height}/${iconXML.innerText}";
        iconHeight = height;
      } else if (height > remoteIconHeight) {
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

    List<String> screenshots = [];
    var screenshotsParent =
        componentElement.findElements('screenshots').firstOrNull;
    if (screenshotsParent != null) {
      for (var screenshot in screenshotsParent.findElements('screenshot')) {
        for (var image in screenshot.findElements('image')) {
          screenshots.add(image.innerText);
        }
      }
    }

    List<String> keywords = [];
    var keywordsParent = componentElement.findElements('keywords').firstOrNull;
    if (keywordsParent != null) {
      for (var keyword in keywordsParent.findElements('keyword')) {
        keywords.add(keyword.innerText);
      }
    }

    Map<String, dynamic> releases = {};
    final releasesParent =
        componentElement.findAllElements('releases').firstOrNull;
    if (releasesParent != null) {
      for (final release in releasesParent.findElements('release')) {
        final version = release.getAttribute('version');
        final type = release.getAttribute('type');
        final timestamp = release.getAttribute('timestamp');

        if (version != null && type != null && timestamp != null) {
          final releaseDetails = {
            'type': type,
            'timestamp': timestamp,
          };
          releases[version] = releaseDetails;
        } else {
          print('  -> WARNING: Skipping malformed release tag.');
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
          print(
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
    );
  }

  List<Application> getAllRemotePackages() {
    List<Application> apps = [];
    ffi.Pointer<GPtrArray> remotesPtr = bindings
        .flatpak_installation_list_remotes(installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      final GPtrArray remotesRefs = remotesPtr.ref;
      final int length = remotesRefs.len;
      print('Found $length remote references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = remotesRefs.pdata;

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;
        final ffi.Pointer<FlatpakRemote> remotePtr =
            refVoidPtr.cast<FlatpakRemote>();
        final ffi.Pointer<ffi.Char> namePtr =
            bindings.flatpak_remote_get_name(remotePtr);
        // print("HERE YOU FOOL: ${namePtr.cast<pkg_ffi.Utf8>().toDartString()}");
        final ffi.Pointer<GPtrArray> remotesRefSyncPtr =
            bindings.flatpak_installation_list_remote_refs_sync(
                installationPtr, namePtr, ffi.nullptr, error);
        if (error.value == ffi.nullptr) {
          final GPtrArray remotesRefSyncRef = remotesRefSyncPtr.ref;
          // final int remotesLength = remotesRefSyncRef.len;
          final ffi.Pointer<gpointer> remotesPdataPtr = remotesRefSyncRef.pdata;
          for (int j = 0; j < 50; j++) {
            final ffi.Pointer<ffi.Void> refRemoteVoidPtr =
                remotesPdataPtr.elementAt(j).value;
            final ffi.Pointer<FlatpakRemoteRef> remoteRefPtr =
                refRemoteVoidPtr.cast<FlatpakRemoteRef>();
            // final ffi.Pointer<ffi.Char> remoteName =
            //     bindings.flatpak_remote_ref_get_remote_name(remoteRefPtr);
            // print(
            //     "Remote name: ${remoteName.cast<pkg_ffi.Utf8>().toDartString()}");
            final ffi.Pointer<GBytes> remoteRefMetadata =
                bindings.flatpak_remote_ref_get_metadata(remoteRefPtr);
            if (error.value == ffi.nullptr) {
              final int refRemoteSize =
                  bindings.g_bytes_get_size(remoteRefMetadata);
              final sizeP = pkg_ffi.malloc<gsize>();
              sizeP.value = refRemoteSize;
              final gconstpointer metaDataPtr =
                  bindings.g_bytes_get_data(remoteRefMetadata, sizeP);
              final ffi.Pointer<ffi.Void> void_ptr = metaDataPtr;
              final String metaDataString = utf8.decode(voidptr.value);
              print(metaDataString);
            } else {
              print("Error occurred.");
              error.value = ffi.nullptr;
            }
          }
        } else {
          // final ffi.Pointer<GError> gError = error.value;

          // // // Get the message pointer from the struct
          // final ffi.Pointer<ffi.Char> cMessage = gError.ref.message;

          // // // Convert the C string (Pointer<Char>) to a Dart String
          // final String errorMessage = cMessage.cast<pkg_ffi.Utf8>().toDartString();
          print("Error syncing flatpak remotes.");
          error.value = ffi.nullptr;
        }
      }
    } else {
      print("Error getting flatpak remotes: ${this.error.value}");
      error.value = ffi.nullptr;
    }
    return apps;
  }
}
