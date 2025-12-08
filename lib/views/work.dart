import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/categories_card.dart';
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
          child: GraphicsCategoryCard(
        apps: gameApps.where((app) => app.featured).toList().take(5).toList(),
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
          child: NetworkCategoryCard(
        apps:
            networkApps.where((app) => app.featured).toList().take(5).toList(),
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
          child: UtilityCategoryCard(
        apps:
            utilityApps.where((app) => app.featured).toList().take(5).toList(),
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
          child: EducationCategoryCard(
        apps: educationApps
            .where((app) => app.featured)
            .toList()
            .take(5)
            .toList(),
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
          child: ProductivityCategoryCard(
        apps: officeApps.where((app) => app.featured).toList().take(5).toList(),
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
          child: DevelopementCategoryCard(
        apps: devApps.where((app) => app.featured).toList().take(5).toList(),
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
