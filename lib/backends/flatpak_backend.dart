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
            final document = XmlDocument.parse(xmlString);
            apps.add(appFromXML(document));
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

  Application appFromXML(XmlDocument document) {
    final componentElement = document.findAllElements('component').firstOrNull;

    if (componentElement == null) {
      throw XmlParserException(
          "Error: Could not find the main <component> tag.");
    }

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
    final icons =
        componentElement.findAllElements('icon').map((icon) => icon.innerText);

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
    final releasesParent = document.findAllElements('releases').firstOrNull;
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
        document.findAllElements('content_rating').firstOrNull;

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
    final customParent = document.findAllElements('custom').firstOrNull;
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
      icon: icons.firstWhereOrNull(
          (path) => path.startsWith('http') && path.endsWith('.png')),
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
}
