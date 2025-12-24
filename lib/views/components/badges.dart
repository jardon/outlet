import '../../core/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme.dart';

class FeaturedBadge extends StatelessWidget {
  const FeaturedBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: featuredColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            'lib/views/assets/featured-icon.svg',
            semanticsLabel: 'Featured Application',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 2,
            width: size / 2,
          ),
        ));
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      SvgPicture.asset(
        'lib/views/assets/verified-icon.svg',
        semanticsLabel: 'Verified Application',
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        height: size,
        width: size,
      ),
      Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.done,
            color: Colors.white,
            size: size / 2,
          )),
    ]);
  }
}

class InstalledBadge extends StatelessWidget {
  const InstalledBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size * 2.25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: const Text(
          "Installed",
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }
}

class VideoBadge extends StatelessWidget {
  const VideoBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: videoColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.video.icon,
            semanticsLabel: 'Video',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class AudioBadge extends StatelessWidget {
  const AudioBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: audioColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.audio.icon,
            semanticsLabel: 'Audio',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class DevelopmentBadge extends StatelessWidget {
  const DevelopmentBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: devColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.development.icon,
            semanticsLabel: 'Development',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.3,
            width: size / 1.3,
          ),
        ));
  }
}

class GameBadge extends StatelessWidget {
  const GameBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: gameColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.game.icon,
            semanticsLabel: 'Games',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class GraphicsBadge extends StatelessWidget {
  const GraphicsBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: graphicsColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            'lib/views/assets/graphics-icon.svg',
            semanticsLabel: 'Graphics',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 2,
            width: size / 2,
          ),
        ));
  }
}

class NetworkBadge extends StatelessWidget {
  const NetworkBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: networkColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.network.icon,
            semanticsLabel: 'Audio/Video',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class UtilityBadge extends StatelessWidget {
  const UtilityBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: utilityColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.utility.icon,
            semanticsLabel: 'Utility',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class EducationBadge extends StatelessWidget {
  const EducationBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: educationColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.education.icon,
            semanticsLabel: 'Education',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class OfficeBadge extends StatelessWidget {
  const OfficeBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: officeColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.office.icon,
            semanticsLabel: 'Office',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class ScienceBadge extends StatelessWidget {
  const ScienceBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: scienceColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.science.icon,
            semanticsLabel: 'Science',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class SettingsBadge extends StatelessWidget {
  const SettingsBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: settingsColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.settings.icon,
            semanticsLabel: 'Settings',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class SystemBadge extends StatelessWidget {
  const SystemBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: systemColors,
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            Category.system.icon,
            semanticsLabel: 'System',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.333,
            width: size / 1.333,
          ),
        ));
  }
}

class FlatpakBadge extends StatelessWidget {
  const FlatpakBadge({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: <Color>[
              Colors.grey.shade600,
              Colors.grey,
            ],
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            'lib/views/assets/flatpak-icon.svg',
            semanticsLabel: 'Flatpak',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: size / 1.5,
            width: size / 1.5,
          ),
        ));
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({
    super.key,
    required this.size,
    required this.categories,
  });

  final double size;
  final List<String> categories;
  final List<Widget> badges = [];

  @override
  Widget build(BuildContext context) {
    for (String cat in categories) {
      switch (cat) {
        case "audio":
          badges.add(AudioBadge(size: size));
          break;
        case 'video':
          badges.add(VideoBadge(size: size));
          break;
        case 'graphics':
          badges.add(GraphicsBadge(size: size));
          break;
        case 'network':
          badges.add(NetworkBadge(size: size));
          break;
        case 'game':
          badges.add(GameBadge(size: size));
          break;
        case 'development':
          badges.add(DevelopmentBadge(size: size));
          break;
        case 'utility':
          badges.add(UtilityBadge(size: size));
          break;
        case 'education':
          badges.add(EducationBadge(size: size));
          break;
        case 'office':
          badges.add(OfficeBadge(size: size));
          break;
        case 'featured':
          badges.add(FeaturedBadge(size: size));
          break;
        case 'flatpak':
          badges.add(FlatpakBadge(size: size));
          break;
        case 'science':
          badges.add(ScienceBadge(size: size));
          break;
        case 'settings':
          badges.add(SettingsBadge(size: size));
          break;
        case 'system':
          badges.add(SystemBadge(size: size));
          break;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: badges,
    );
  }
}
