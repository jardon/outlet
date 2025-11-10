import '../backends/backend.dart';
import '../backends/flatpak_backend.dart';
import '../core/application.dart';
import 'dart:io';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appListProvider = FutureProvider<List<Application>>((ref) async {
  Map<String, String> env = Platform.environment;
  List<Application> apps = [];
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return TestBackend().getInstalledPackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(FlatpakBackend().getAllRemotePackages());
  }
  return apps;
});

final installedAppListProvider = Provider((ref) {
  Map<String, String> env = Platform.environment;
  List<Application> apps = [];
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return TestBackend().getInstalledPackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(FlatpakBackend().getInstalledPackages());
  }
  return apps;
});
