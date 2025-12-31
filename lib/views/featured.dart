import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/app_list.dart';
import 'package:outlet/views/components/category_card.dart';
import 'package:outlet/views/components/theme.dart';

class Featured extends ConsumerWidget {
  const Featured({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allApps = (ref
        .watch(appListProvider)
        .values
        .toList()
        .where((app) => app.featured)
        .toList());
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(
          child: CategoryCard(
        apps: allApps.take(5).toList(),
        colors: featuredColorsAlt,
        icon: 'lib/views/assets/featured-icon.svg',
        title: 'Featured',
        showFeaturedBadge: false,
      )),
      SliverToBoxAdapter(
          child: SizedBox(
              child: AppList(
        apps: allApps.sublist(5),
        scrollable: false,
        shrinkWrap: true,
      ))),
    ]);
  }
}
