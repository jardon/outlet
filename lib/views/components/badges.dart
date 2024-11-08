import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedBadge extends StatelessWidget {

    final double size;

    FeaturedBadge({
        super.key,
        required this.size,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            height: size,
            width: size,
            margin: EdgeInsets.symmetric(horizontal: 5),
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
                    height: 20,
                    width: 20,
                ),
            )
        );
    }
}


class VerifiedBadge extends StatelessWidget {

    final double size;

    VerifiedBadge({
        super.key,
        required this.size,
    });

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

    final double size;

    InstalledBadge({
        super.key,
        required this.size,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            height: size,
            width: size * 2.25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.grey[400]!,
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

    final double size;

    VideoBadge({
        super.key,
        required this.size,
    });

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
                    height: 30,
                    width: 30,
                ),
            )
        );
    }
}


class AudioBadge extends StatelessWidget {

    final double size;

    AudioBadge({
        super.key,
        required this.size,
    });

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
                    height: 30,
                    width: 30,
                ),
            )
        );
    }
}


class DevelopmentBadge extends StatelessWidget {

    final double size;

    DevelopmentBadge({
        super.key,
        required this.size,
    });

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
                    height: 25,
                    width: 25,
                ),
            )
        );
    }
}

// Education	Educational software	 

class GameBadge extends StatelessWidget {

    final double size;

    GameBadge({
        super.key,
        required this.size,
    });

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
                    height: 30,
                    width: 30,
                ),
            )
        );
    }
}


class GraphicsBadge extends StatelessWidget {

    final double size;

    GraphicsBadge({
        super.key,
        required this.size,
    });

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
                    height: 20,
                    width: 20,
                ),
            )
        );
    }
}


class NetworkBadge extends StatelessWidget {

    final double size;

    NetworkBadge({
        super.key,
        required this.size,
    });

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
                    height: 30,
                    width: 30,
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

    final double size;
    final List<String> categories;

    CategoryList({
        super.key,
        required this.size,
        required this.categories,
    });

    final List<Widget> badges = [];

    @override
    Widget build(BuildContext context) {
        for (String cat in categories) {
            switch (cat) {
            case "audio":
                badges.add(AudioBadge(size: 40.0));
            case 'video':
                badges.add(VideoBadge(size: 40.0));
            case 'graphics':
                badges.add(GraphicsBadge(size: 40.0));
            case 'network':
                badges.add(NetworkBadge(size: 40.0));
            case 'game':
                badges.add(GameBadge(size: 40.0));
            case 'development':
                badges.add(DevelopmentBadge(size: 40.0));
            }
        }
        return Row(
            children: badges,
        );
    }
}
