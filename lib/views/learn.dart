import '../core/category.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/category_link.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Learn extends ConsumerWidget {
  const Learn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scienceApps = (ref.watch(appInCategoryList("science"))..shuffle());
    final educationApps =
        (ref.watch(appInCategoryList("education"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: CategoryCard(
        apps:
            scienceApps.where((app) => app.featured).toList().take(5).toList(),
        colors: scienceColors,
        icon: Category.science.icon,
        title: Category.science.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: scienceApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(
          child:
              CategoryLink(category: CategoryLabel.science, title: 'Science')),
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
      const SliverToBoxAdapter(
          child: CategoryLink(
              category: CategoryLabel.education, title: 'Education')),
    ]);
  }
}
