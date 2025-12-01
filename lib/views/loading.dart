import '../core/application.dart';
import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Loading extends ConsumerWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, Application>> apps =
        ref.watch(remoteAppListProvider);

    return apps.when(
      loading: () => const Center(
        child: Text(
          'LOADING',
          style: TextStyle(fontSize: 32, color: Colors.black),
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (apps) => Navigation(
          title: "Featured", child: AppList(apps: apps.values.toList())),
    );
  }
}
