import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/featured.dart';
import 'package:outlet/views/navigation.dart';

class Loading extends ConsumerWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, Application>> remoteApps =
        ref.watch(remoteAppListProvider);
    ref.watch(featuredAppList);

    return remoteApps.when(
      loading: () => const Center(
        child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              Text('Loading application data...',
                  style: TextStyle(fontSize: 24, color: Colors.white))
            ]),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (apps) => const Navigation(title: "Featured", child: Featured()),
    );
  }
}
