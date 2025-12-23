import '../core/category.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Relax extends ConsumerWidget {
  const Relax({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioApps = (ref.watch(appInCategoryList("audio"))..shuffle());
    final videoApps = (ref.watch(appInCategoryList("video"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: videoApps.where((app) => app.featured).toList().take(5).toList(),
        colors: videoColors,
        icon: Category.video.icon,
        title: Category.video.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: videoApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: audioApps.where((app) => app.featured).toList().take(5).toList(),
        colors: audioColors,
        icon: Category.audio.icon,
        title: Category.audio.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: audioApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
    ]);
  }
}
