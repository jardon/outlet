import '../../core/application.dart';
import '../../providers/action_queue.dart';
import '../../providers/backend_provider.dart';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppActions extends ConsumerWidget {
  final Application app;

  const AppActions({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(backendProvider);
    final actionQueue = ref.watch(actionQueueProvider);
    return Container(
      width: 400,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(spacing: 10, children: [
          TextButton(
            onPressed: () {
              app.installed
                  ? Isolate.run(() {
                      backend.uninstallApplication(
                          "app/${app.id}/${backend.arch}/stable");
                    })
                  : actionQueue.add("installing ${app.id}", () async {
                      backend.installApplication(app.bundle!, app.remote!);
                    });
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.black),
            ),
            child: Text(app.installed ? 'Uninstall' : 'Install',
                style: const TextStyle(color: Colors.white)),
          ),
          Expanded(child: Container()),
          Text(app.branch != null
              ? '${app.branch![0].toUpperCase()}${app.branch!.substring(1)}'
              : ''),
        ]),
      ),
    );
  }
}
