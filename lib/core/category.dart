import '../views/components/theme.dart';
import 'package:flutter/material.dart';

// reference: https://specifications.freedesktop.org/menu/latest/category-registry.html

enum Category {
  audio('Audio', 'audio', 'lib/views/assets/audio-icon.svg'),
  video('Video', 'video', 'lib/views/assets/video-icon.svg'),
  game('Gaming', 'game', 'lib/views/assets/gaming-icon.svg'),
  development(
      'Development', 'development', 'lib/views/assets/development-icon.svg'),
  network('Networking', 'network', 'lib/views/assets/network-icon.svg'),
  utility('Utility', 'utility', 'lib/views/assets/utility-icon.svg'),
  education('Education', 'education', 'lib/views/assets/education-icon.svg'),
  graphics('Graphics', 'graphics', 'lib/views/assets/graphics-icon.svg'),
  science('Science', 'science', 'lib/views/assets/science-icon.svg'),
  settings('Settings', 'settings', 'lib/views/assets/settings-icon.svg'),
  system('System', 'system', 'lib/views/assets/system-icon.svg'),
  office('Office', 'office', 'lib/views/assets/office-icon.svg');

  const Category(this.label, this.category, this.icon);

  final String label;
  final String category;
  final String icon;

  List<Color> get colors {
    switch (this) {
      case Category.audio:
        return audioColors;
      case Category.video:
        return videoColors;
      case Category.game:
        return gameColorsAlt;
      case Category.development:
        return devColors;
      case Category.network:
        return networkColors;
      case Category.utility:
        return utilityColors;
      case Category.education:
        return educationColors;
      case Category.office:
        return officeColors;
      case Category.graphics:
        return graphicsColors;
      case Category.science:
        return scienceColors;
      case Category.settings:
        return settingsColors;
      case Category.system:
        return systemColors;
    }
  }
}
