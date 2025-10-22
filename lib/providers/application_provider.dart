import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../backends/backend.dart';
import '../backends/flatpak_backend.dart';

final appListProvider = Provider((ref) {
  Map<String, String> env = Platform.environment;
  List<dynamic> apps = [];
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return TestBackend().getInstalledPackages().values.toList();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(FlatpakBackend().getInstalledPackages().values.toList());
  }
  return apps;
});
