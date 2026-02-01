import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:outlet/backends/flatpak_backend.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/core/flatpak_application.dart';
import 'package:outlet/appstream.dart/lib/appstream.dart';

interface class Backend {
  Map<String, bool> getInstalledPackages() {
    return {};
  }

  Future<Map<String, Application>> getAllRemotePackages() async {
    return {};
  }

  Future<bool> installApplication(String id, String remote) =>
      Future.value(true);

  Future<bool> uninstallApplication(String id) => Future.value(true);

  Future<bool> updateApplication(String id) => Future.value(true);
}

class TestBackend implements Backend {
  Map<String, Application> apps;

  TestBackend() : apps = {} {
    Random random = Random();

    List<String> categoriesList = [
      "audio",
      "video",
      "game",
      "development",
      "network",
      "graphics"
    ];

    for (int i = 1; i <= 50; i++) {
      String appId = "app-$i";

      List<String> pickedCategories =
          _pickRandomCategories(categoriesList, 2, random);

      apps[appId] = FlatpakApplication(
        name: {"C": "App $i"},
        id: appId,
        icons: const [AppstreamLocalIcon("lib/views/assets/flatpak-icon.svg")],
        description: {"C": "Description for App $i"},
        package: null,
        summary: {"C": "Summary text for App $i"},
        type: AppstreamComponentType.generic,
        categories: pickedCategories, // Randomly picked categories
        installed: random.nextBool(),
        custom: [
          {'flathub::verification::verified': "${random.nextBool()}"}
        ],
        featured: random.nextBool(),
      );
    }
  }

  List<String> _pickRandomCategories(
      List<String> categoriesList, int count, Random random) {
    categoriesList.shuffle(random);
    return categoriesList.take(count).toList();
  }

  @override
  Map<String, bool> getInstalledPackages() {
    return {'app-3': true, 'app-7': false};
  }

  @override
  Future<Map<String, Application>> getAllRemotePackages() async {
    return apps;
  }

  @override
  Future<bool> installApplication(String id, String remote) =>
      Future.value(true);

  @override
  Future<bool> uninstallApplication(String id) => Future.value(true);

  @override
  Future<bool> updateApplication(String id) => Future.value(true);

  void destroy() {}
}

Backend getBackend() {
  Map<String, String> env = Platform.environment;
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return TestBackend();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    return FlatpakBackend();
  }
  return TestBackend();
}
