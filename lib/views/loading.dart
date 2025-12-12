import '../core/application.dart';
import '../providers/application_provider.dart';
import 'featured.dart';
import 'navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Loading extends ConsumerWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, Application>> remoteApps =
        ref.watch(remoteAppListProvider);

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
