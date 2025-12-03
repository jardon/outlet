import '../core/application.dart';
import 'backend_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteAppListProvider =
    FutureProvider<Map<String, Application>>((ref) async {
  final backend = ref.watch(backendProvider);
  Map<String, String> env = Platform.environment;
  Map<String, Application> apps = {};
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return backend.getInstalledPackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    apps.addAll(backend.getAllRemotePackages());
  }
  return apps;
});

final installedAppListProvider = AutoDisposeNotifierProvider<
    InstalledAppListNotifier,
    Map<String, Application>>(InstalledAppListNotifier.new);

class InstalledAppListNotifier
    extends AutoDisposeNotifier<Map<String, Application>> {
  Map<String, Application> _getInstalledPackages() {
    final backend = ref.read(backendProvider);
    Map<String, String> env = Platform.environment;
    Map<String, Application> apps = {};

    if (env['TEST_BACKEND_ENABLED'] != null) {
      return backend.getInstalledPackages();
    }

    if (env['FLATPAK_ENABLED'] != null) {
      apps.addAll(backend.getInstalledPackages());
    }
    return apps;
  }

  @override
  Map<String, Application> build() {
    return _getInstalledPackages();
  }

  void refresh() {
    state = _getInstalledPackages();
  }
}

final appListProvider = Provider((ref) {
  final remoteApps = ref.watch(remoteAppListProvider).value ?? {};
  final installedApps = ref.watch(installedAppListProvider);
  final allApps = {...remoteApps, ...installedApps};
  return allApps;
});
