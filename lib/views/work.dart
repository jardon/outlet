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
    final gameApps = ref.watch(appInCategoryList("game"));
    final networkApps = ref.watch(appInCategoryList("network"));
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
    ]);
  }
}
