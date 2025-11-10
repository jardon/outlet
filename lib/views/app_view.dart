import '../core/application.dart';
import 'components/app_description.dart';
import 'components/app_info.dart';
import 'components/review_info.dart';
import 'components/screenshots.dart';
import 'components/screenshots_expanded.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  AppView({
    super.key,
    required this.app,
  });

  final Application app;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: LayoutBuilder(builder: (context, constraints) {
              const double breakpoint = 850.0;
              final bool isWide = constraints.maxWidth > breakpoint;
              final double viewportHeight =
                  constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;
              final double availableWidth = constraints.maxWidth;

              return isWide
                  ? Container(
                      constraints: BoxConstraints(minHeight: viewportHeight),
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      alignment: Alignment.topCenter,
                      child: Row(
                          spacing: 16.0,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(spacing: 16.0, children: [
                              AppInfo(app: app),
                              AppDescription(app: app),
                              ReviewInfo(reviews: []),
                            ]),
                            ScreenshotsExpanded(screenshots: app.screenshots),
                          ]))
                  : Container(
                      width: availableWidth,
                      constraints: BoxConstraints(minHeight: viewportHeight),
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Column(spacing: 16.0, children: [
                        AppInfo(app: app),
                        AppDescription(app: app),
                        Screenshots(screenshots: app.screenshots),
                        ReviewInfo(reviews: []),
                      ]));
            })));
  }
}
