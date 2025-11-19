import '../core/application.dart';
import 'backend_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appListProvider = FutureProvider<List<Application>>((ref) async {
  final backend = ref.watch(backendProvider);
  Map<String, String> env = Platform.environment;
  List<Application> apps = [];
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return backend.getInstalledPackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(backend.getAllRemotePackages());
  }
  return apps;
});

final installedAppListProvider = Provider((ref) {
  final backend = ref.watch(backendProvider);
  Map<String, String> env = Platform.environment;
  List<Application> apps = [];
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return backend.getInstalledPackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(backend.getInstalledPackages());
  }
  return apps;
});
