import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/app_list.dart';

class ThisDevice extends ConsumerWidget {
  const ThisDevice({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appListProvider);

    return AppList(
        apps: apps.values.where((app) => app.installed).toList(),
        details: false);
  }
}
