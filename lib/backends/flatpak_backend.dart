import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:libflatpak/libflatpak.dart';
import './backend.dart';

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
  }

  Map<String, Map<String, dynamic>> getInstalledPackages() {
    Map<String, Map<String, dynamic>> data = {};
    final ffi.Pointer<GPtrArray> installed_refs =
        bindings.flatpak_installation_list_installed_refs(
            installationPtr, ffi.nullptr, error);

    if (installed_refs != ffi.nullptr) {
      final GPtrArray installedRefs = installed_refs.ref;
      final int length = installedRefs.len;
      print('Found $length installed references (apps and runtimes).');
      final ffi.Pointer<gpointer> pdataPtr = installedRefs.pdata;

      for (int i = 0; i < length; i++) {
        final ffi.Pointer<ffi.Void> refVoidPtr = pdataPtr.elementAt(i).value;

        final ffi.Pointer<FlatpakRef> refPtr = refVoidPtr.cast<FlatpakRef>();

        final ffi.Pointer<ffi.Char> namePtr =
            bindings.flatpak_ref_get_name(refPtr);

        final String appId = namePtr.cast<pkg_ffi.Utf8>().toDartString();

        data[appId] = {
          "name": appId,
          "icon": "lib/views/assets/flatpak-icon.svg",
          "description": "Description for App $appId",
          "rating": null,
          "categories": <String>[],
          "installed": true,
          "verified": false,
          "featured": false,
          "reviews": [],
        };
      }
      pkg_ffi.calloc.free(pdataPtr);
    }
    return data;
  }
}
