import '../../core/application.dart';
import 'app_icon_loader.dart';
import 'badges.dart';
import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.app,
    this.details = true,
    this.size = 300,
  });

  final bool details;
  final int size;
  final Application app;
  final borderRadius = 45.0;
  final cardWidth = 300.0;
  final cardHeight = 340.0;

  @override
  AppCardState createState() => AppCardState();
}

class AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
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
    return FittedBox(
        child: Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20.0)
                ]),
            child: MouseRegion(
              onEnter: (_) => _onHoverChanged(true),
              onExit: (_) => _onHoverChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: Stack(children: <Widget>[
                  Listing(
                    featured: widget.app.featured,
                    verified: widget.app.verified,
                    installed: widget.app.installed,
                    name: widget.app.name ?? widget.app.id,
                    icon: widget.app.icon,
                    categories: widget.app.categories,
                    rating: widget.app.rating,
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
                                name: widget.app.name ?? widget.app.id,
                                summary: widget.app.summary ??
                                    "No summary available.",
                                categories: widget.app.categories,
                              ),
                            ),
                          ))
                      : const Center(),
                ]),
              ),
            )));
  }
}

class Listing extends StatelessWidget {
  const Listing({
    super.key,
    required this.featured,
    required this.verified,
    required this.installed,
    required this.name,
    required this.icon,
    required this.categories,
    this.rating,
  });

  final bool featured;
  final bool verified;
  final bool installed;
  final String name;
  final String icon;
  final cardWidth = 300.0;
  final cardHeight = 340.0;
  final List<String> categories;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cardWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 35),
            Expanded(
                child: SizedBox(
                    width: cardWidth,
                    child: AppIconLoader(
                      icon: icon,
                    ))),
            const SizedBox(height: 15),
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
              !verified ? const Center() : const VerifiedBadge(size: 40.0),
            ]),
          ],
        ));
  }
}

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.name,
    required this.summary,
    required this.categories,
    this.cardWidth = 300.0,
    this.cardHeight = 340.0,
  });

  final String name;
  final String summary;
  final List<String> categories;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Expanded(
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        summary,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ))),
              CategoryList(size: 50, categories: categories),
            ])));
  }
}
