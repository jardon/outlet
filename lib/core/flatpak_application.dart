import 'application.dart';
import 'dart:core';

class FlatpakApplication extends Application {
  final String? type;
  final Bundle? bundle;

  FlatpakApplication({
    required super.id,
    super.name,
    super.summary,
    super.license,
    super.description,
    super.developer,
    String? icon,
    super.homepage,
    super.help,
    super.translate,
    super.vcs,
    super.categories = const [],
    super.screenshots = const [],
    super.keywords = const [],
    super.releases = const [],
    super.content = const {},
    super.featured = false,
    super.verified = false,
    super.installed = false,
    super.reviews = const [],
    this.type,
    this.bundle,
    super.remote,
    super.version,
    super.branch,
    super.current = true,
    super.arch,
  }) : super(
          icon: icon ?? "lib/views/assets/flatpak-icon.svg",
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
        case 'Network' || 'P2P':
          categoryBadges.add('network');
          break;
        case 'InstantMessaging' || 'Chat' || 'VideoConference':
          categoryBadges.add('social');
          break;
        case 'TextEditor' || 'IDE' || 'Developement':
          categoryBadges.add('development');
          break;
        case 'Game' || 'ActionGame' || 'Shooter' || 'Sports':
          categoryBadges.add('game');
          break;
        case 'Audio' || 'Music':
          categoryBadges.add('audio');
          break;
        case 'Video':
          categoryBadges.add('video');
          break;
        case 'AudioVideo':
          categoryBadges.add('audio');
          categoryBadges.add('video');
          break;
        case 'Utility' ||
              'System' ||
              'Settings' ||
              'Archiving' ||
              'Monitorying':
          categoryBadges.add('utility');
          break;
        case 'Literature' || 'Astronomy' || 'Science' || 'Education':
          categoryBadges.add('education');
          break;
        case 'Office':
          categoryBadges.add('office');
          break;
      }
    }
    return categoryBadges.toList();
  }

  @override
  String getInstallTarget() {
    if (bundle != null) {
      return bundle?.value as String;
    } else {
      return id;
    }
  }

  @override
  String getUninstallTarget() {
    if (bundle != null) {
      return bundle?.value as String;
    } else if (type != null && branch != null && arch != null) {
      return "$type/$id/$arch/$branch";
    } else {
      return id;
    }
  }
}

class Bundle {
  final String? type;
  final String? runtime;
  final String? sdk;
  final String value;

  Bundle({
    this.type,
    this.runtime,
    this.sdk,
    required this.value,
  });
}
