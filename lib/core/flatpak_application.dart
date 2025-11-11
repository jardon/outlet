import 'application.dart';
import 'dart:core';

class FlatpakApplication extends Application {
  FlatpakApplication({
    required String id,
    String? name,
    String? summary,
    String? license,
    String? description,
    String? developer,
    String? icon,
    String? homepage,
    String? help,
    String? translate,
    String? vcs,
    List<String> categories = const [],
    List<String> screenshots = const [],
    List<String> keywords = const [],
    Map<String, dynamic> releases = const {},
    Map<String, String> content = const {},
    bool featured = false,
    bool verified = false,
    bool installed = false,
    List<dynamic> reviews = const [],
  }) : super(
          id: id,
          name: name,
          summary: summary,
          license: license,
          description: description,
          developer: developer,
          icon: icon ?? "lib/views/assets/flatpak-icon.svg",
          homepage: homepage,
          help: help,
          translate: translate,
          vcs: vcs,
          categories: categories,
          screenshots: screenshots,
          keywords: keywords,
          releases: releases,
          content: content,
          featured: featured,
          verified: verified,
          installed: installed,
          reviews: reviews,
        );

  @override
  double? get rating {
    return null;
  }

  @override
  List<String> get categories {
    Set<String> categoryBadges = {};
    for (var category in super.categories) {
      switch (category) {
        case 'Network':
          categoryBadges.add('network');
          break;
        case 'InstantMessaging' || 'Chat' || 'VideoConference':
          categoryBadges.add('social');
          break;
        case 'TextEditor' || 'IDE' || 'Developement':
          categoryBadges.add('development');
          break;
        case 'Game':
          categoryBadges.add('game');
          break;
      }
    }
    return categoryBadges.toList();
  }
}
