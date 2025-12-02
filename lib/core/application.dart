import 'dart:core';

abstract class Application {
  Application({
    required this.id,
    this.name,
    this.summary,
    this.license,
    this.description,
    this.developer,
    required this.icon,
    this.homepage,
    this.help,
    this.translate,
    this.vcs,
    this.categories = const [],
    this.screenshots = const [],
    this.keywords = const [],
    this.releases = const [],
    this.content = const {},
    this.featured = false,
    this.verified = false,
    this.installed = false,
    this.reviews = const [],
    this.bundle,
    this.remote,
    this.version,
    this.branch,
    this.current,
    this.arch,
  });

  final String id;
  final String? name;
  final String? summary;
  final String? license;
  final String? description;
  final String? developer;
  final String icon;
  final String? homepage;
  final String? help;
  final String? translate;
  final String? vcs;
  final List<String> categories;
  final List<Screenshot> screenshots;
  final List<String> keywords;
  final List<Release> releases;
  final Map<String, String> content;
  final bool featured;
  final bool verified;
  final bool installed;
  final List<dynamic> reviews;
  final String? bundle;
  double? get rating;
  final String? remote;
  final String? version;
  String? branch;
  bool? current;
  String? arch;
}

class Screenshot {
  final String thumb;
  final String full;
  final String? caption;

  Screenshot({
    required this.thumb,
    required this.full,
    this.caption,
  });
}

class Release {
  final String? version;
  final String? timestamp;
  final String? type;
  final String? description;

  Release({
    this.version,
    this.timestamp,
    this.type,
    this.description,
  });
}
