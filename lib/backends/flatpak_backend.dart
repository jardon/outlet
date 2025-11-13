import '../core/application.dart';
import '../core/flatpak_application.dart';
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

  @override
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
          pkg_ffi.malloc.free(sizeP);
        } else {
          print(
              'Failed to load appdata. GError pointer received: ${this.error.value}');
          error.value = ffi.nullptr;
          final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;
          final ffi.Pointer<FlatpakRef> refPtr = refVoidPtr.cast<FlatpakRef>();
          final ffi.Pointer<ffi.Char> namePtr =
              bindings.flatpak_ref_get_name(refPtr);
          final String id = namePtr.cast<pkg_ffi.Utf8>().toDartString();
          apps.add(FlatpakApplication(
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

  Application appFromXML(XmlElement componentElement, String deployDir) {
    final id = componentElement.findElements('id').firstOrNull?.text.trim();
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
        name = nameElement.text.trim();
      }
    }

    String? summary;
    for (var summaryElement in componentElement.findAllElements('summary')) {
      if (summaryElement.getAttribute('xml:lang') == null) {
        summary = summaryElement.text.trim();
      }
    }

    final license = componentElement
        .findElements('project_license')
        .firstOrNull
        ?.text
        .trim();

    String? description;
    for (var descriptionElement
        in componentElement.findAllElements('description')) {
      if (descriptionElement.getAttribute('xml:lang') == null) {
        description = descriptionElement.text.trim();
      }
    }

    String? developer;
    for (var devElement in componentElement.findAllElements('name').where(
      (element) {
        return element.parentElement?.name.local == 'developer';
      },
    )) {
      if (devElement.getAttribute('xml:lang') == null) {
        developer = devElement.text.trim();
      }
    }

    String? icon = null;
    String? remoteIcon = null;
    int iconHeight = 0;
    int remoteIconHeight = 0;
    for (var iconXML in componentElement.findAllElements('icon')) {
      String? heightAttr = iconXML.getAttribute('height');
      int height = (heightAttr != null) ? int.parse(heightAttr) : 0;
      if (iconXML.getAttribute('type') == 'cached' && height > iconHeight) {
        icon = (deployDir.startsWith("/var/lib/flatpak/appstream"))
            ? "${deployDir}/icons/${height}x${height}/${iconXML.innerText}"
            : "${deployDir}/files/share/app-info/icons/flatpak/${height}x${height}/${iconXML.innerText}";
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

  @override
  List<Application> getAllRemotePackages() {
    List<Application> apps = [];
    ffi.Pointer<GPtrArray> remotesPtr = bindings
        .flatpak_installation_list_remotes(installationPtr, ffi.nullptr, error);
    if (error.value == ffi.nullptr) {
      String? appstreamXmlContent;
      final GPtrArray remotesRefs = remotesPtr.ref;
      final int length = remotesRefs.len;
      print('Found $length remote references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = remotesRefs.pdata;
      final ffi.Pointer<ffi.Char> archPtr = bindings.flatpak_get_default_arch();

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;
        final ffi.Pointer<FlatpakRemote> remotePtr =
            refVoidPtr.cast<FlatpakRemote>();
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
                apps.add(appFromXML(componentElement, appstreamDir));
              }
            } on XmlParserException catch (e) {
              print('Error parsing XML: $e');
            }
          }
        } else {
          print("Error occurred.");
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
