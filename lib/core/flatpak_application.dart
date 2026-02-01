import 'dart:core';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:outlet/appstream.dart/lib/appstream.dart';
import 'package:outlet/core/application.dart';

class FlatpakApplication extends Application {
  final String? deployDir;

  FlatpakApplication({
    required super.id,
    super.type = AppstreamComponentType.unknown,
    super.package,
    super.name,
    super.summary = const {"C": "No summary available"},
    super.description = const {},
    super.developerName = const {},
    super.projectLicense,
    super.projectGroup,
    super.icons = const [
      AppstreamLocalIcon("lib/views/assets/flatpak-icon.svg")
    ],
    super.urls = const [],
    super.categories = const [],
    super.keywords = const {},
    super.screenshots = const [],
    super.compulsoryForDesktops = const [],
    super.releases = const [],
    super.provides = const [],
    super.launchables = const [],
    super.languages = const [],
    super.contentRatings = const {},
    super.featured = false,
    super.installed = false,
    super.remote,
    super.version,
    super.current,
    super.bundles,
    super.custom,
    this.deployDir,
  });

  @override
  List<String> get categories {
    Set<String> categoryBadges = {};
    var audioVideo = false;
    var audio = false;
    var video = false;

    for (var category in super.categories) {
      switch (category) {
        case 'Network':
          categoryBadges.add('network');
          break;
        case 'Development':
          categoryBadges.add('development');
          break;
        case 'Game':
          categoryBadges.add('game');
          break;
        case 'Audio':
          categoryBadges.add('audio');
          audio = true;
          break;
        case 'Video':
          categoryBadges.add('video');
          video = true;
          break;
        case 'Utility':
          categoryBadges.add('utility');
          break;
        case 'Education':
          categoryBadges.add('education');
          break;
        case 'Office':
          categoryBadges.add('office');
          break;
        case 'Graphics':
          categoryBadges.add('graphics');
          break;
        case 'Science':
          categoryBadges.add('science');
          break;
        case 'Settings':
          categoryBadges.add('settings');
          break;
        case 'System':
          categoryBadges.add('system');
          break;
        case 'AudioVideo':
          audioVideo = true;
          break;
      }

      if (audioVideo && !audio && !video) {
        categoryBadges.addAll(['audio', 'video']);
      }
    }
    return categoryBadges.toList();
  }

  @override
  String get icon {
    final localIcons = icons.whereType<AppstreamLocalIcon>();
    final cachedIcons = icons.whereType<AppstreamCachedIcon>();
    final remoteIcons = icons.whereType<AppstreamRemoteIcon>();

    if (localIcons.isNotEmpty) return localIcons.first.filename;

    if (cachedIcons.isNotEmpty && deployDir != null) {
      var iconList = cachedIcons.toList();
      iconList.sort((a, b) => (b.height ?? 0).compareTo(a.height ?? 0));
      var icon = iconList.firstOrNull;
      if (icon != null) {
        String cachedIcon = (deployDir!
                .startsWith("/var/lib/flatpak/appstream"))
            ? "$deployDir/icons/${icon.height}x${icon.width}/${icon.name}"
            : "$deployDir/files/share/app-info/icons/flatpak/${icon.height}x${icon.width}/${icon.name}";
        var file = File(cachedIcon);
        if (file.existsSync()) return cachedIcon;
      }
    }

    if (remoteIcons.isEmpty) return "lib/views/assets/flatpak-icon.svg";

    return remoteIcons
        .reduce((a, b) => (a.height ?? 0) > (b.height ?? 0) ? a : b)
        .url;
  }

  @override
  bool get verified {
    for (var item in custom) {
      var verifiedCustomValue = item['flathub::verification::verified'];
      if (verifiedCustomValue != null) {
        return bool.parse(verifiedCustomValue);
      }
    }
    return false;
  }

  @override
  String getInstallTarget() {
    if (bundles.isNotEmpty) {
      return bundles.first.id;
    } else {
      return id;
    }
  }

  @override
  String getUninstallTarget() {
    if (bundles.isNotEmpty) {
      return bundles.first.id;
    } else {
      return id;
    }
  }

  @override
  getUpdateTarget() => bundles.firstOrNull?.id ?? id;

  @override
  String launchCommand() {
    return "flatpak run $id";
  }
}
