import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/core/category.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/app_list.dart';
import 'package:outlet/views/components/category_card.dart';
import 'package:outlet/views/components/category_link.dart';
import 'package:outlet/views/components/theme.dart';

class Play extends ConsumerWidget {
  const Play({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioApps =
        (ref.watch(appInCategoryList(Category.audio.value))..shuffle());
    final videoApps =
        (ref.watch(appInCategoryList(Category.video.value))..shuffle());
    final gameApps =
        (ref.watch(appInCategoryList(Category.game.value))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
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
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.audio, title: Category.audio.label)),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.video, title: Category.video.label)),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: gameApps.where((app) => app.featured).toList().take(5).toList(),
        colors: gameColorsAlt,
        icon: Category.game.icon,
        title: Category.game.label,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: gameApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      SliverToBoxAdapter(
          child: CategoryLink(
              category: Category.game, title: Category.game.label)),
    ]);
  }
}
