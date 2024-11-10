import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'review.dart';
import 'badges.dart';


class AppCard extends StatelessWidget {

    AppCard({
        super.key,
        required this.featured,
        required this.verified,
        required this.installed,
        this.details = true,
        required this.name,
        required this.iconUrl,
        required this.description,
    });
    
    final bool featured;
    final bool verified;
    final bool installed;
    final bool details;
    final String name;
    final String iconUrl;
    final String description;
    final borderRadius = 45.0;
    final cardWidth = 300.0;
    final cardHeight = 400.0;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 20.0
                    )
                ]
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Container(
                    height: cardHeight,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                            Listing(
                                featured: featured,
                                verified: verified,
                                installed: installed,
                                name: name,
                                iconUrl: iconUrl,
                            ),
                            details ? Details(
                                name: name,
                                description: description,
                            ) : Center(),
                        ],
                    ),
                ),
            ),
        );
    }
}

class Listing extends StatelessWidget {

    Listing({
        super.key,
        required this.featured,
        required this.verified,
        required this.installed,
        required this.name,
        required this.iconUrl,
    });
    
    final bool featured;
    final bool verified;
    final bool installed;
    final String name;
    final String iconUrl;
    final cardWidth = 300.0;
    final cardHeight = 400.0;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: cardWidth,
            height: cardHeight,
            child: Column(
                children: <Widget>[
                    Container(
                        height: cardHeight * .2,
                        width: cardWidth,
                        child: Row(
                            children: <Widget>[
                                Container(
                                    width: cardWidth - 130.0,
                                    height: cardHeight * .2,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                        children: <Widget>[
                                            !featured ? Center() : FeaturedBadge(
                                                size: 40.0,
                                            ),
                                            !verified ? Center() : VerifiedBadge(
                                                size: 40.0
                                            ),
                                        ]
                                    )
                                ),
                                Container(
                                    width: 130.0,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.all(20),
                                    child: !installed ? Center() : InstalledBadge(
                                        size: 40.0
                                    ),
                                ),
                            ]
                        )
                    ),
                    Container(
                        height: cardHeight * .6 ,
                        width: cardWidth,
                        child: SvgPicture.network(
                                    iconUrl,
                                    semanticsLabel: 'App Icon',
                                    placeholderBuilder: (BuildContext context) => Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: const CircularProgressIndicator()
                                    ),
                                )
                    ),
                    Container(
                        height: cardHeight * .2,
                        width: cardWidth,
                        child: Row(
                            children: <Widget>[
                                Container(
                                    width: cardWidth * .6,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    )
                                ),
                                Container(
                                    width: cardWidth * .4,
                                    height: cardHeight * .2,
                                    child: ReviewScore(
                                        score: 4.0,
                                        size: 40.0,
                                        )
                                )
                            ]
                        )
                    ),
                ],
            )
        );
    }
}

class Details extends StatelessWidget {

    Details({
        super.key,
        required this.name,
        required this.description,
    });
    
    final String name;
    final String description;
    final cardWidth = 300.0;
    final cardHeight = 400.0;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(45.0),
            ),
            child: Column(
                children: <Widget>[
                    Container(
                        height: cardHeight * .2,
                        padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                        alignment: Alignment.topLeft,
                        child: Text(
                            name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                            ),
                        )
                    ),
                    Container(
                        height: cardHeight * .8,
                        padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                        alignment: Alignment.topLeft,
                        child: Text(
                            description,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                            ),
                        )
                    )
                ]
            )
        );
    }
}
