import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Build extends ConsumerWidget {
  const Build({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameApps = (ref.watch(appInCategoryList("game"))..shuffle());
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
    ]);
  }
}
