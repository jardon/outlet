import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.yellow,
                        Colors.orange,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/star-icon.svg',
                    semanticsLabel: 'Featured Application',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 2,
                    width: size / 2,
                ),
            )
        );
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
        return Stack(
            alignment: Alignment.center,
            children: <Widget>[
            SvgPicture.asset(
                'lib/views/assets/verified-icon.svg',
                semanticsLabel: 'Verified Application',
                colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                height: size,
                width: size,
            ),
            Align(
                alignment: Alignment.center,
                child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: size / 2,
                )
            ),
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
            child: Text(
                "Installed",
                style: TextStyle(
                    color: Colors.black,
                ),
            )
        );
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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.green,
                        Colors.blue,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/beads-icon.svg',
                    semanticsLabel: 'Video',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 1.333,
                    width: size / 1.333,
                ),
            )
        );
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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.red,
                        Colors.orange,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/layered-circles-icon.svg',
                    semanticsLabel: 'Audio',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 1.333,
                    width: size / 1.333,
                ),
            )
        );
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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.green,
                        Colors.lime,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/bug-icon.svg',
                    semanticsLabel: 'Audio/Video',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 1.6,
                    width: size / 1.6,
                ),
            )
        );
    }
}

// Education	Educational software	 

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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.green,
                        Colors.yellow,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/dpad-icon.svg',
                    semanticsLabel: 'Audio/Video',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 1.333,
                    width: size / 1.333,
                ),
            )
        );
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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.purple,
                        Colors.pink,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/checkered-icon.svg',
                    semanticsLabel: 'Audio/Video',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 2,
                    width: size / 2,
                ),
            )
        );
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
            margin: EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.pink,
                        Colors.red,
                    ],
                    tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                    'lib/views/assets/connected-icon.svg',
                    semanticsLabel: 'Audio/Video',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: size / 1.333,
                    width: size / 1.333,
                ),
            )
        );
    }
}


// Office	An office type application	 
// Science	Scientific software	 
// Settings	Settings applications	Entries may appear in a separate menu or as part of a "Control Center"
// System	System application, "System Tools" such as say a log viewer or network monitor	 
// Utility	Small utility application, "Accessories"


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
            case 'video':
                badges.add(VideoBadge(size: size));
            case 'graphics':
                badges.add(GraphicsBadge(size: size));
            case 'network':
                badges.add(NetworkBadge(size: size));
            case 'game':
                badges.add(GameBadge(size: size));
            case 'development':
                badges.add(DevelopmentBadge(size: size));
            case 'featured':
                badges.add(FeaturedBadge(size: size));
            }
        }
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: badges,
        );
    }
}
