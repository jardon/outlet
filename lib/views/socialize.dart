import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'components/categories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Socialize extends ConsumerWidget {
  const Socialize({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameApps = ref.watch(appInCategoryList("game"));
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
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
