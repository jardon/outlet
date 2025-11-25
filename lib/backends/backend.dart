import "dart:math";
import "dart:core";
import "../core/application.dart";
import "../core/flatpak_application.dart";

interface class Backend {
  late String arch;

  List<Application> getInstalledPackages() {
    return [];
  }

  List<Application> getAllRemotePackages() {
    return [];
  }

  Future<bool> installApplication(String id, String remote) =>
      Future.value(true);

  Future<bool> uninstallApplication(String id) => Future.value(true);
}

class TestBackend implements Backend {
  @override
  String arch = "x86_64";
  List<Application> apps;

  TestBackend() : apps = [] {
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

      apps.add(FlatpakApplication(
        name: "App $i",
        id: appId,
        icon: "lib/views/assets/flatpak-icon.svg",
        description: "Description for App $i",
        categories: pickedCategories, // Randomly picked categories
        installed: random.nextBool(),
        verified: random.nextBool(),
        featured: random.nextBool(),
        reviews: [
          {
            "title": "Review for App $i",
            "rating": random.nextInt(5) +
                1, // Random rating between 1 and 5 for review
            "message": "This is a review message for App $i.",
          }
        ],
      ));
    }
  }

  List<String> _pickRandomCategories(
      List<String> categoriesList, int count, Random random) {
    categoriesList.shuffle(random);
    return categoriesList.take(count).toList();
  }

  @override
  List<Application> getInstalledPackages() {
    return apps;
  }

  @override
  List<Application> getAllRemotePackages() {
    return apps;
  }

  @override
  Future<bool> installApplication(String id, String remote) =>
      Future.value(true);

  @override
  Future<bool> uninstallApplication(String id) => Future.value(true);

  void destroy() {}
}
