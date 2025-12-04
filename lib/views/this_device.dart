import '../providers/application_provider.dart';
import 'components/app_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThisDevice extends ConsumerWidget {
  const ThisDevice({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(installedAppListProvider);

    return AppList(apps: apps.values.toList(), details: false);
  }
}
