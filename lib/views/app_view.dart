import 'package:flutter/material.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/views/components/app_description.dart';
import 'package:outlet/views/components/app_info.dart';
import 'package:outlet/views/components/app_links.dart';
import 'package:outlet/views/components/app_update.dart';
import 'package:outlet/views/components/screenshots.dart';

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
                                      AppInfo(id: app!.id),
                                      AppUpdate(id: app!.id),
                                      AppDescription(app: app!),
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
                            AppInfo(id: app!.id),
                            AppUpdate(id: app!.id),
                            AppDescription(app: app!),
                            Screenshots(screenshots: app!.screenshots),
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
