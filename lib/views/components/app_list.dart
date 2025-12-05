import '../../../core/application.dart';
import '../app_view.dart';
import '../navigation.dart';
import 'app_card.dart';
import 'package:flutter/material.dart';

class AppList extends StatelessWidget {
  const AppList({
    super.key,
    required this.apps,
    this.details = true,
    this.scrollable = true,
  });

  final List<Application> apps;
  final bool details;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int crossAxisCount = (width / 160).floor();

        crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 3 / 3.4,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            itemCount: apps.length,
            physics: scrollable
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics())
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
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
                  details: details,
                ),
              );
            });
      },
    );
  }
}
