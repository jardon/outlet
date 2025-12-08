import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/categories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Play extends ConsumerWidget {
  const Play({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioApps = (ref.watch(appInCategoryList("audio"))..shuffle());
    final videoApps = (ref.watch(appInCategoryList("video"))..shuffle());
    final gameApps = (ref.watch(appInCategoryList("game"))..shuffle());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: VideoCategoryCard(
        apps: videoApps.where((app) => app.featured).toList().take(5).toList(),
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
          child: AudioCategoryCard(
        apps: audioApps.where((app) => app.featured).toList().take(5).toList(),
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: audioApps,
        scrollable: false,
        rows: 2,
        shrinkWrap: true,
      ))),
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: GameCategoryCard(
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
    ]);
  }
}
