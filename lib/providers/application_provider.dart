import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:core';
import '../backends/backend.dart';
import '../backends/flatpak_backend.dart';
import '../core/application.dart';

final appListProvider = Provider((ref) {
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
