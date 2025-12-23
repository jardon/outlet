import '../core/category.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Work extends ConsumerWidget {
  const Work({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameApps = (ref.watch(appInCategoryList("game"))..shuffle());
    final networkApps = (ref.watch(appInCategoryList("network"))..shuffle());
    final utilityApps = (ref.watch(appInCategoryList("utility"))..shuffle());
    final educationApps =
        (ref.watch(appInCategoryList("education"))..shuffle());
    final officeApps =
        (ref.watch(appInCategoryList("productivity"))..shuffle());
    final devApps = (ref.watch(appInCategoryList("development"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: gameApps.where((app) => app.featured).toList().take(5).toList(),
        colors: graphicsColors,
        icon: 'lib/views/assets/graphics-icon.svg',
        title: 'Graphics',
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: gameApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps:
            networkApps.where((app) => app.featured).toList().take(5).toList(),
        colors: networkColors,
        icon: Category.network.icon,
        title: Category.network.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: networkApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps:
            utilityApps.where((app) => app.featured).toList().take(5).toList(),
        colors: utilityColors,
        icon: Category.utility.icon,
        title: Category.utility.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: utilityApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: educationApps
            .where((app) => app.featured)
            .toList()
            .take(5)
            .toList(),
        colors: educationColors,
        icon: Category.education.icon,
        title: Category.education.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: educationApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: officeApps.where((app) => app.featured).toList().take(5).toList(),
        colors: productivityColors,
        icon: Category.productivity.icon,
        title: Category.productivity.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: officeApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: devApps.where((app) => app.featured).toList().take(5).toList(),
        colors: devColors,
        icon: Category.development.icon,
        title: Category.development.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: devApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
    ]);
  }
}
