import 'package:flutter/material.dart';
import 'package:outlet/appstream.dart/lib/appstream.dart';
import 'package:outlet/views/screenshots_view.dart';
import 'package:outlet/views/components/theme.dart';

class Screenshots extends StatelessWidget {
  final List<AppstreamScreenshot> screenshots;

  const Screenshots({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = fgColor(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (screenshots.isEmpty)
            ? const Center(child: Text("No screenshots available."))
            : ScreenshotsList(screenshots: screenshots),
      ),
    );
  }
}

class ScreenshotsList extends StatelessWidget {
  final List<AppstreamScreenshot> screenshots;

  const ScreenshotsList({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: screenshots.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideAndFadeAnimationPageRoute(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ScreenshotsView(
                          screenshot: screenshots[index]
                              .images
                              .firstWhere((image) =>
                                  image.type == AppstreamImageType.source)
                              .url,
                        ),
                      ),
                    );
                  },
                  child: Center(
                      child: Image.network(
                    screenshots[index]
                        .images
                        .firstWhere((image) =>
                            image.type == AppstreamImageType.thumbnail)
                        .url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Error loading image');
                    },
                  )))),
        );
      },
    );
  }
}

class ScreenshotsGrid extends StatelessWidget {
  final List<AppstreamScreenshot> screenshots;

  const ScreenshotsGrid({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int crossAxisCount = (width / 100).floor();

        crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            itemCount: screenshots.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideAndFadeAnimationPageRoute(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ScreenshotsView(
                            screenshot: screenshots[index]
                                .images
                                .firstWhere((image) =>
                                    image.type == AppstreamImageType.source)
                                .url,
                          ),
                        ),
                      );
                    },
                    child: Center(
                        child: Image.network(
                      screenshots[index]
                          .images
                          .firstWhere((image) =>
                              image.type == AppstreamImageType.thumbnail)
                          .url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Error loading image');
                      },
                    )),
                  ));
            });
      },
    );
  }
}

class ScreenshotsExpanded extends StatelessWidget {
  final List<AppstreamScreenshot> screenshots;

  const ScreenshotsExpanded({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> fullSizeWidgets = screenshots.take(2).map((screenshot) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideAndFadeAnimationPageRoute(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ScreenshotsView(
                    screenshot: screenshot.images
                        .firstWhere(
                            (image) => image.type == AppstreamImageType.source)
                        .url,
                  ),
                ),
              );
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  screenshot.images
                      .firstWhere(
                          (image) => image.type == AppstreamImageType.source)
                      .url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Error loading image');
                  },
                ))),
      );
    }).toList();

    final List<AppstreamScreenshot> thumbSize =
        screenshots.length > 2 ? screenshots.sublist(2) : [];
    final Color color = fgColor(context);

    return Container(
      height: (screenshots.isEmpty) ? 600.0 : null,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (screenshots.isEmpty)
            ? const Center(child: Text("No screenshots available."))
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: fullSizeWidgets,
                ),
                if (thumbSize.isNotEmpty)
                  SizedBox(
                      height: 100,
                      child: ScreenshotsGrid(screenshots: thumbSize))
              ]),
      ),
    );
  }
}

class SlideAndFadeAnimationPageRoute<T> extends PageRouteBuilder<T> {
  SlideAndFadeAnimationPageRoute({required super.pageBuilder})
      : super(
          transitionDuration: const Duration(milliseconds: 100),
          reverseTransitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );

            const beginSlide = Offset(1.0, 0.0);
            const endSlide = Offset.zero;
            final slideTween = Tween(begin: beginSlide, end: endSlide);

            const beginFade = 0.0;
            const endFade = 1.0;
            final fadeTween = Tween(begin: beginFade, end: endFade);

            return SlideTransition(
              position: slideTween.animate(curve),
              child: FadeTransition(
                opacity: fadeTween.animate(curve),
                child: child,
              ),
            );
          },
        );
}
