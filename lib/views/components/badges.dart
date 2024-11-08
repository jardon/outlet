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
