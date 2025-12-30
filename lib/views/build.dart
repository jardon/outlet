import '../core/category.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/category_link.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Build extends ConsumerWidget {
  const Build({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final developmentApps =
        (ref.watch(appInCategoryList("development"))..shuffle());
    final networkApps = (ref.watch(appInCategoryList("network"))..shuffle());
    final graphicsApps = (ref.watch(appInCategoryList("graphics"))..shuffle());
    final officeApps = (ref.watch(appInCategoryList("office"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: developmentApps
            .where((app) => app.featured)
            .toList()
            .take(5)
            .toList(),
        colors: devColors,
        icon: Category.development.icon,
        title: Category.development.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: developmentApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.development, title: 'Development')),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps:
            graphicsApps.where((app) => app.featured).toList().take(5).toList(),
        colors: graphicsColors,
        icon: Category.graphics.icon,
        title: Category.graphics.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: graphicsApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.graphics, title: 'Graphics')),
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
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.network, title: 'Networking')),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: officeApps.where((app) => app.featured).toList().take(5).toList(),
        colors: officeColors,
        icon: Category.office.icon,
        title: Category.office.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: officeApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child: CategoryLink(category: CategoryLabel.office, title: 'Office')),
    ]);
  }
}
