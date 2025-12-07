import '../../core/application.dart';
import '../app_view.dart';
import '../navigation.dart';
import 'app_card.dart';
import 'badges.dart';
import 'dart:async';
import 'screenshots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const FeaturedCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: <Color>[
        Colors.yellow.shade700,
        Colors.orange,
      ],
      icon: 'lib/views/assets/star-icon.svg',
      title: 'Featured',
      showFeaturedBadge: false,
    );
  }
}

class VideoCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const VideoCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.green,
        Colors.blue,
      ],
      icon: 'lib/views/assets/beads-icon.svg',
      title: 'Video',
    );
  }
}

class AudioCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const AudioCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.red,
        Colors.orange,
      ],
      icon: 'lib/views/assets/layered-circles-icon.svg',
      title: 'Audio',
    );
  }
}

class GameCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const GameCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.green,
        Colors.lime,
      ],
      icon: 'lib/views/assets/dpad-icon.svg',
      title: 'Gaming',
    );
  }
}

class GraphicsCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const GraphicsCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.purple,
        Colors.pink,
      ],
      icon: 'lib/views/assets/checkered-icon.svg',
      title: 'Gaphics',
    );
  }
}

class NetworkCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const NetworkCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.pink,
        Colors.red,
      ],
      icon: 'lib/views/assets/connected-icon.svg',
      title: 'Networking',
    );
  }
}

class UtilityCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const UtilityCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.pink,
        Colors.purple,
      ],
      icon: 'lib/views/assets/cross-circle-bloat-icon.svg',
      title: 'Utility',
    );
  }
}

class EducationCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const EducationCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.blue,
        Colors.purple,
      ],
      icon: 'lib/views/assets/circle-quarter-leaf-icon.svg',
      title: 'Education',
    );
  }
}

class ProductivityCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const ProductivityCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.blue,
        Colors.yellow,
      ],
      icon: 'lib/views/assets/shape-circle-halves-icon.svg',
      title: 'Productivity',
    );
  }
}

class DevelopementCategoryCard extends StatelessWidget {
  final List<Application> apps;

  const DevelopementCategoryCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      apps: apps,
      colors: const <Color>[
        Colors.green,
        Colors.lime,
      ],
      icon: 'lib/views/assets/bug-icon.svg',
      title: 'Developement',
    );
  }
}

class CategoryCard extends StatefulWidget {
  final List<Application> apps;
  final List<Color> colors;
  final String icon;
  final String title;
  final bool showFeaturedBadge;

  const CategoryCard({
    super.key,
    required this.apps,
    required this.colors,
    required this.icon,
    required this.title,
    this.showFeaturedBadge = true,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  int _currentIndex = 0;
  bool interrupted = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (!interrupted) {
          _currentIndex = (_currentIndex + 1) % widget.apps.length;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextItem() {
    setState(() {
      interrupted = true;
      _currentIndex = (_currentIndex + 1) % widget.apps.length;
    });
  }

  void _previousItem() {
    setState(() {
      interrupted = true;
      _currentIndex =
          (_currentIndex - 1 + widget.apps.length) % widget.apps.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45.0),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 15.0)
              ]),
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: const Alignment(0.8, 1),
                  colors: widget.colors,
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(spacing: 5, children: [
                Row(spacing: 10, children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(
                      widget.icon,
                      semanticsLabel: widget.title,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      height: 35,
                      width: 35,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
                  Row(children: [
                    if (widget.apps.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          _previousItem();
                        },
                        tooltip: 'Go Backward',
                      ),
                    if (widget.apps.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          _nextItem();
                        },
                        tooltip: 'Go Forward',
                      )
                  ]),
                  widget.showFeaturedBadge && widget.apps.isNotEmpty
                      ? const FeaturedBadge(size: 40)
                      : Container(),
                ]),
                if (widget.apps.isNotEmpty)
                  CategorySpotlightSlideshow(
                      apps: widget.apps, index: _currentIndex),
              ])),
        ));
  }
}

class CategorySpotlightSlideshow extends StatelessWidget {
  final List<Application> apps;
  final int index;

  const CategorySpotlightSlideshow({
    super.key,
    required this.apps,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CategorySpotlight(apps: apps, index: index);
  }
}

class CategorySpotlight extends StatelessWidget {
  final List<Application> apps;
  final int index;

  const CategorySpotlight({
    super.key,
    required this.apps,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const double breakpoint = 600.0;
      final bool isWide = constraints.maxWidth > breakpoint;
      return isWide
          ? SizedBox(
              height: 200,
              child: Row(spacing: 10, children: [
                SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            pageBuilder: (context, animation1, animation2) =>
                                Navigation(
                              title: "App Info",
                              child: AppView(app: apps[index]) as Widget,
                            ),
                          ),
                        );
                      },
                      child: AppCard(
                        app: apps[index],
                        details: false,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                      (apps[index].description ??
                                              "No description available.")
                                          .trimLeft(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      overflow: TextOverflow.fade,
                                      softWrap: true))),
                        ])),
                Expanded(
                    flex: 1,
                    child:
                        ScreenshotsGrid(screenshots: apps[index].screenshots))
              ]))
          : SizedBox(
              height: 200,
              child: Row(spacing: 10, children: [
                SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            pageBuilder: (context, animation1, animation2) =>
                                Navigation(
                              title: "App Info",
                              child: AppView(app: apps[index]) as Widget,
                            ),
                          ),
                        );
                      },
                      child: AppCard(
                        app: apps[index],
                        details: false,
                      ),
                    )),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                  (apps[index].description ??
                                          "No description available.")
                                      .trimLeft(),
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.fade,
                                  softWrap: true))),
                      SizedBox(
                          height: 80,
                          child: ScreenshotsList(
                              screenshots: apps[index].screenshots)),
                    ])),
              ]));
    });
  }
}
