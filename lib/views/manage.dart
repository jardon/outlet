import '../core/category.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/category_link.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Manage extends ConsumerWidget {
  const Manage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemApps = (ref.watch(appInCategoryList("system"))..shuffle());
    final utilityApps = (ref.watch(appInCategoryList("utility"))..shuffle());
    final settingsApps = (ref.watch(appInCategoryList("settings"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
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
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.utility, title: 'Utilities')),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps:
            settingsApps.where((app) => app.featured).toList().take(5).toList(),
        colors: settingsColors,
        icon: Category.settings.icon,
        title: Category.settings.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: settingsApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.settings, title: 'Settings')),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: systemApps.where((app) => app.featured).toList().take(5).toList(),
        colors: systemColors,
        icon: Category.system.icon,
        title: Category.system.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: systemApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child: CategoryLink(category: CategoryLabel.system, title: 'System')),
    ]);
  }
}
