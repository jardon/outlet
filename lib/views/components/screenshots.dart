import '../screenshots_view.dart';
import 'package:flutter/material.dart';

class Screenshots extends StatelessWidget {
  final List<dynamic> screenshots;

  const Screenshots({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> fullSizedScreenshots =
        screenshots.where((image) => image.contains('orig')).toList();
    return Container(
      width: 400,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (fullSizedScreenshots.isEmpty)
            ? const Center(child: Text("No screenshots available."))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: fullSizedScreenshots.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideAndFadeAnimationPageRoute(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ScreenshotsView(
                                    screenshot: fullSizedScreenshots[index],
                                  ),
                                ),
                              );
                            },
                            child: Center(
                                child: Image.network(
                              fullSizedScreenshots[index],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
              ),
      ),
    );
  }
}

class ScreenshotsExpanded extends StatelessWidget {
  final List<dynamic> screenshots;

  const ScreenshotsExpanded({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    final fullSizedScreenshots =
        screenshots.where((image) => image.contains('orig')).toList();
    return Container(
      width: 400,
      height: (fullSizedScreenshots.isEmpty) ? 600.0 : null,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (fullSizedScreenshots.isEmpty)
            ? const Center(child: Text("No screenshots available."))
            : ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: fullSizedScreenshots.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideAndFadeAnimationPageRoute(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ScreenshotsView(
                                screenshot: fullSizedScreenshots[index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              fullSizedScreenshots[index],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                },
              ),
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
