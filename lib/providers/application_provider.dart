import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/core/logger.dart';
import 'package:outlet/providers/backend_provider.dart';

final remoteAppListProvider =
    FutureProvider<Map<String, Application>>((ref) async {
  await Future.microtask(() {});
  final backend = ref.watch(backendProvider);
  Map<String, String> env = Platform.environment;
  Map<String, Application> apps = {};
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return backend.getAllRemotePackages();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    final flapaks = await Isolate.run(() => backend.getAllRemotePackages());
    apps.addAll(flapaks);
  }
  return apps;
});

final installedAppListProvider =
    AutoDisposeNotifierProvider<InstalledAppListNotifier, List<String>>(
        InstalledAppListNotifier.new);

class InstalledAppListNotifier extends AutoDisposeNotifier<List<String>> {
  List<String> _getInstalledPackages() {
    final backend = ref.read(backendProvider);
    Map<String, String> env = Platform.environment;
    List<String> apps = [];

    if (env['TEST_BACKEND_ENABLED'] != null) {
      return backend.getInstalledPackages();
    }

    if (env['FLATPAK_ENABLED'] != null) {
      apps.addAll(backend.getInstalledPackages());
    }
    return apps;
  }

  @override
  List<String> build() {
    return _getInstalledPackages();
  }

  void refresh() {
    state = _getInstalledPackages();
  }
}

final featuredAppList = FutureProvider<List<String>>((ref) async {
  try {
    final String jsonString = await rootBundle.loadString('featured.json');

    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    final List<dynamic>? featuredIds = jsonMap['featured_app_ids'];

    if (featuredIds == null) {
      return <String>[];
    }

    return featuredIds.cast<String>();
  } catch (e) {
    logger.e('Error loading applications from JSON: $e');
    return <String>[];
  }
});

final appListProvider = Provider((ref) {
  final remoteApps = ref.watch(remoteAppListProvider).value ?? {};
  final installedApps = ref.watch(installedAppListProvider);
  final featuredApps = ref.watch(featuredAppList);

  // if (installedApps.hasValue)
  for (var app in installedApps) {
    try {
      remoteApps[app]!.installed = true;
    } catch (e) {
      logger.w('Failed to find $app in installed list.');
    }
  }

  if (featuredApps.hasValue) {
    List<String> featured = featuredApps.value!;

    for (var app in featured) {
      try {
        remoteApps[app]!.featured = true;
      } catch (e) {
        logger.w('Failed to find $app in featured list.');
      }
    }
  }
  return remoteApps;
});

final searchKeywordsProvider = Provider((ref) {
  final allApps = ref.watch(appListProvider);

  return allApps.map((key, app) {
    if (app.name["C"] != null) {
      return MapEntry(
          "${app.name["C"]!.toLowerCase()} ${(app.keywords['C'] ?? []).join(' ')}",
          key);
    } else {
      return MapEntry(key.toLowerCase(), key);
    }
  });
});

final liveApplicationProvider =
    Provider.family<Application?, String>((ref, appId) {
  final allApps = ref.watch(appListProvider);

  return allApps[appId];
});

final appInCategoryList =
    Provider.family<List<Application>, String>((ref, category) {
  final allApps = ref.watch(appListProvider);

  return allApps.values
      .toList()
      .where((app) => app.categories.contains(category))
      .toList();
});
