import '../views/components/theme.dart';
import 'package:flutter/material.dart';

enum Category {
  audio('Audio', 'audio', 'lib/views/assets/audio-icon.svg'),
  video('Video', 'video', 'lib/views/assets/video-icon.svg'),
  game('Gaming', 'game', 'lib/views/assets/gaming-icon.svg'),
  development(
      'Development', 'development', 'lib/views/assets/development-icon.svg'),
  network('Networking', 'network', 'lib/views/assets/network-icon.svg'),
  utility('Utility', 'utility', 'lib/views/assets/utility-icon.svg'),
  education('Education', 'education', 'lib/views/assets/utility-icon.svg'),
  productivity(
      'Productivity', 'productivity', 'lib/views/assets/productivity-icon.svg');

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
      case Category.productivity:
        return productivityColors;
    }
  }
}
