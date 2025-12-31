import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/core/category.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/app_list.dart';
import 'package:outlet/views/components/category_card.dart';
import 'package:outlet/views/components/category_link.dart';
import 'package:outlet/views/components/theme.dart';

class Manage extends ConsumerWidget {
  const Manage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemApps =
        (ref.watch(appInCategoryList(Category.system.value))..shuffle());
    final utilityApps =
        (ref.watch(appInCategoryList(Category.utility.value))..shuffle());
    final settingsApps =
        (ref.watch(appInCategoryList(Category.settings.value))..shuffle());
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
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.utility, title: Category.utility.label)),
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
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.settings, title: Category.settings.label)),
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
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.system, title: Category.system.label)),
    ]);
  }
}
