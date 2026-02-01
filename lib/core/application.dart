import 'dart:core';
import 'dart:ui';
import 'package:outlet/appstream.dart/lib/appstream.dart';

class Application extends AppstreamComponent {
  Application({
    required super.id,
    required super.type,
    required super.package,
    Map<String, String>? name,
    required super.summary,
    super.description = const {},
    super.developerName = const {},
    super.projectLicense,
    super.projectGroup,
    super.icons = const [],
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
    super.bundles = const [],
    super.custom = const [],
    this.featured = false,
    this.installed = false,
    this.remote,
    this.version,
    this.current,
  }) : super(name: name ?? {"C": id});

  bool featured;
  bool installed;
  final String? remote;
  final String? version;
  bool? current;

  String getLocalizedName() {
    final key = bestLanguageKey(name);
    return name.getOrDefault(key, '');
  }

  String getLocalizedDeveloperName() {
    final key = bestLanguageKey(name);
    return developerName.getOrDefault(key, '');
  }

  List<String> getLocalizedKeywords() {
    final key = bestLanguageKey(keywords);
    return keywords.getOrDefault(key, []);
  }

  String getLocalizedSummary() {
    final key = bestLanguageKey(summary);
    return summary.getOrDefault(key, '');
  }

  String getLocalizedDescription() {
    final key = bestLanguageKey(description);
    return description.getOrDefault(key, '');
  }

  String? bestLanguageKey<T>(Map<String, T> keyedByLanguage) {
    final locale = PlatformDispatcher.instance.locale;

    if (locale.toLanguageTag() == 'und') return null;

    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final fullLocale = '${languageCode}_$countryCode';
    const fallback = 'C';
    final candidates = [fullLocale, languageCode, fallback];
    final keys = keyedByLanguage.keys;

    for (final candidate in candidates) {
      if (keys.contains(candidate)) return candidate;
    }

    return null;
  }

  String get icon {
    final localIcons = icons.whereType<AppstreamLocalIcon>();
    final remoteIcons = icons.whereType<AppstreamRemoteIcon>();

    if (localIcons.isNotEmpty) return localIcons.first.filename;

    if (remoteIcons.isEmpty) return "";

    return remoteIcons
        .reduce((a, b) => (a.height ?? 0) > (b.height ?? 0) ? a : b)
        .url;
  }

  bool get verified => false;

  String getInstallTarget() => id;

  String getUninstallTarget() => id;

  String getUpdateTarget() => id;

  String launchCommand() => id;
}

extension _GetOrDefault<K, V> on Map<K, V> {
  V getOrDefault(K? key, V fallback) {
    if (key == null) {
      return fallback;
    }

    return this[key] ?? fallback;
  }
}
