import '../core/application.dart';
import '../core/logger.dart';
import 'backend_provider.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
  final allApps = {...remoteApps, ...installedApps};

  if (featuredApps.hasValue) {
    List<String> featured = featuredApps.value!;

    for (var app in featured) {
      try {
        allApps[app]!.featured = true;
      } catch (e) {
        logger.w('Failed to find $app in featured list.');
      }
    }
  }
  return allApps;
});

final liveApplicationProvider =
    Provider.family<Application?, String>((ref, appId) {
  final allApps = ref.watch(appListProvider);

  return allApps[appId];
});

final appInCategoryList =
    Provider.family<List<Application>, String>((ref, category) {
  final allApps = ref.watch(remoteAppListProvider);

  if (allApps.hasValue) {
    return allApps.value!.values
        .toList()
        .where((app) => app.categories.contains(category))
        .toList();
  }

  return [];
});
