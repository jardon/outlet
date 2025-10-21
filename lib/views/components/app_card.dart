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
    required this.categories,
    this.size = 300,
    required this.rating,
  });

  final bool featured;
  final bool verified;
  final bool installed;
  final bool details;
  final String name;
  final String iconUrl;
  final String description;
  final borderRadius = 45.0;
  final double size;
  final List<String> categories;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: InfoCard(
      featured: featured,
      verified: verified,
      installed: installed,
      details: details,
      name: name,
      iconUrl: iconUrl,
      description: description,
      categories: categories,
      rating: rating,
    ));
  }
}

class InfoCard extends StatefulWidget {
  InfoCard({
    super.key,
    required this.featured,
    required this.verified,
    required this.installed,
    this.details = true,
    required this.name,
    required this.iconUrl,
    required this.description,
    required this.categories,
    required this.rating,
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
  final List<String> categories;
  final double rating;

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovering) {
    if (!widget.details) return;

    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
        child: MouseRegion(
          onEnter: (_) => _onHoverChanged(true),
          onExit: (_) => _onHoverChanged(false),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Container(
              height: widget.cardHeight,
              child: Stack(children: <Widget>[
                Listing(
                  featured: widget.featured,
                  verified: widget.verified,
                  installed: widget.installed,
                  name: widget.name,
                  iconUrl: widget.iconUrl,
                  categories: widget.categories,
                  rating: widget.rating,
                ),
                widget.details
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Details(
                              name: widget.name,
                              description: widget.description,
                            ),
                          ),
                        ))
                    : Center(),
              ]),
            ),
          ),
        ));
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
    required this.categories,
    required this.rating,
  });

  final bool featured;
  final bool verified;
  final bool installed;
  final String name;
  final String iconUrl;
  final cardWidth = 300.0;
  final cardHeight = 400.0;
  final List<String> categories;
  final double rating;

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
                child: Row(children: <Widget>[
                  Container(
                      width: cardWidth - 130.0,
                      height: cardHeight * .2,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(20),
                      child: Row(children: <Widget>[
                        !featured
                            ? Center()
                            : FeaturedBadge(
                                size: 40.0,
                              ),
                        !verified ? Center() : VerifiedBadge(size: 40.0),
                      ])),
                  Container(
                    width: 130.0,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(20),
                    child: !this.installed
                        ? CategoryList(size: 40.0, categories: this.categories)
                        : InstalledBadge(size: 40.0),
                  ),
                ])),
            Container(
                height: cardHeight * .6,
                width: cardWidth,
                child: SvgPicture.asset(
                  iconUrl,
                  semanticsLabel: 'App Icon',
                  colorFilter:
                      ColorFilter.mode(Colors.black12, BlendMode.srcIn),
                )),
            Container(
                height: cardHeight * .2,
                width: cardWidth,
                child: Row(children: <Widget>[
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
                      )),
                  Container(
                      width: cardWidth * .4,
                      height: cardHeight * .2,
                      child: ReviewScore(
                        score: rating,
                        size: 40.0,
                      ))
                ])),
          ],
        ));
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
        child: Column(children: <Widget>[
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
              )),
          Container(
              height: cardHeight * .8,
              padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
              alignment: Alignment.topLeft,
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ))
        ]));
  }
}
