import '../../core/application.dart';
import '../app_view.dart';
import '../navigation.dart';
import 'app_card.dart';
import 'badges.dart';
import 'dart:async';
import 'screenshots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  double _progressValue = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startProgressTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (!interrupted) {
          _currentIndex = (_currentIndex + 1) % widget.apps.length;
          _progressValue = 0.0;
        }
      });
    });
  }

  void _startProgressTimer() {
    const int milliseconds = 50;
    const double increment = milliseconds / 5000;

    _progressTimer =
        Timer.periodic(const Duration(milliseconds: milliseconds), (timer) {
      setState(() {
        if (!interrupted) {
          _progressValue += increment;
          if (_progressValue > 1.0) {
            _progressValue = 1.0;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _resetProgressAndStartInteraction() {
    interrupted = true;
    _progressValue = 0.0;
  }

  void _nextItem() {
    setState(() {
      _resetProgressAndStartInteraction();
      _currentIndex = (_currentIndex + 1) % widget.apps.length;
    });
  }

  void _previousItem() {
    setState(() {
      _resetProgressAndStartInteraction();
      _currentIndex =
          (_currentIndex - 1 + widget.apps.length) % widget.apps.length;
    });
  }

  Widget _transitionBuilder(Widget child, Animation<double> animation) {
    final fadeAnimation =
        CurvedAnimation(parent: animation, curve: Curves.easeInOut);

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }

  Widget _categorySpotlight() {
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
                              child: AppView(app: widget.apps[_currentIndex])
                                  as Widget,
                            ),
                          ),
                        );
                      },
                      child: AppCard(
                        app: widget.apps[_currentIndex],
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
                                      (widget.apps[_currentIndex].description ??
                                              "No description available.")
                                          .trimLeft(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      overflow: TextOverflow.fade,
                                      softWrap: true))),
                        ])),
                Expanded(
                    flex: 1,
                    child: ScreenshotsGrid(
                        screenshots: widget.apps[_currentIndex].screenshots))
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
                              child: AppView(app: widget.apps[_currentIndex])
                                  as Widget,
                            ),
                          ),
                        );
                      },
                      child: AppCard(
                        app: widget.apps[_currentIndex],
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
                                  (widget.apps[_currentIndex].description ??
                                          "No description available.")
                                      .trimLeft(),
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.fade,
                                  softWrap: true))),
                      SizedBox(
                          height: 80,
                          child: ScreenshotsList(
                              screenshots:
                                  widget.apps[_currentIndex].screenshots)),
                    ])),
              ]));
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
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: _progressValue,
                            color: Colors.white,
                            backgroundColor: Colors.white30,
                            strokeWidth: 3.0,
                          ),
                        ),
                      ),
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
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: _transitionBuilder,
                      child: KeyedSubtree(
                          key: ValueKey<int>(_currentIndex),
                          child: _categorySpotlight())),
              ])),
        ));
  }
}
