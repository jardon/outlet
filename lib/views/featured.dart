import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/category_card.dart';
import 'components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        .toList()
      ..shuffle());
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
