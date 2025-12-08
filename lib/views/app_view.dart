import '../core/application.dart';
import 'components/app_actions.dart';
import 'components/app_description.dart';
import 'components/app_info.dart';
import 'components/app_links.dart';
import 'components/review_info.dart';
import 'components/screenshots.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    this.app,
  });

  final Application? app;

  @override
  Widget build(BuildContext context) {
    return (app != null)
        ? Expanded(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: LayoutBuilder(builder: (context, constraints) {
                  const double breakpoint = 850.0;
                  final bool isWide = constraints.maxWidth > breakpoint;
                  final double viewportHeight = constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : 0.0;
                  final double availableWidth = constraints.maxWidth;

                  return isWide
                      ? Container(
                          constraints:
                              BoxConstraints(minHeight: viewportHeight),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                          alignment: Alignment.topCenter,
                          child: Row(
                              spacing: 16.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(spacing: 16.0, children: [
                                      AppInfo(app: app!),
                                      AppActions(id: app!.id),
                                      AppDescription(app: app!),
                                      const ReviewInfo(reviews: []),
                                      AppLinks(app: app!),
                                    ])),
                                Expanded(
                                    flex: 1,
                                    child: ScreenshotsExpanded(
                                        screenshots: app!.screenshots)),
                              ]))
                      : Container(
                          width: availableWidth,
                          constraints:
                              BoxConstraints(minHeight: viewportHeight),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                          child: Column(spacing: 16.0, children: [
                            AppInfo(app: app!),
                            AppActions(id: app!.id),
                            AppDescription(app: app!),
                            Screenshots(screenshots: app!.screenshots),
                            const ReviewInfo(reviews: []),
                            AppLinks(app: app!),
                          ]));
                })))
        : const Center(
            child: Text(
              'No Application Found',
              style: TextStyle(fontSize: 24),
            ),
          );
  }
}
