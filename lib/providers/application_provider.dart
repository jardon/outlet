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
    AutoDisposeNotifierProvider<InstalledAppListNotifier, Map<String, bool>>(
        InstalledAppListNotifier.new);

class InstalledAppListNotifier extends AutoDisposeNotifier<Map<String, bool>> {
  Map<String, bool> _getInstalledPackages() {
    final backend = ref.read(backendProvider);
    Map<String, String> env = Platform.environment;
    Map<String, bool> apps = {};

    if (env['TEST_BACKEND_ENABLED'] != null) {
      return backend.getInstalledPackages();
    }

    if (env['FLATPAK_ENABLED'] != null) {
      apps.addAll(backend.getInstalledPackages());
    }
    return apps;
  }

  @override
  Map<String, bool> build() {
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
  final featuredApps = ref.watch(featuredAppList).value ?? [];

  return remoteApps.map((id, app) {
    return MapEntry(
      id,
      app.copyWith(
        installed: installedApps.containsKey(id),
        featured: featuredApps.contains(id),
      ),
    );
  });
});

final searchKeywordsProvider = Provider((ref) {
  final allApps = ref.watch(appListProvider);

  return allApps.map((key, app) {
    return MapEntry(
        "${app.getLocalizedName().toLowerCase()} ${(app.getLocalizedKeywords()).join(' ')}",
        key);
  });
});

final liveApplicationProvider =
    Provider.family<Application?, String>((ref, appId) {
  final allApps = ref.watch(appListProvider);

  logger.i('Refreshed provider for $appId');

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
