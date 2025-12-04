import '../../backends/backend.dart';
import '../../providers/action_queue.dart';
import '../../providers/application_provider.dart';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppActions extends ConsumerWidget {
  final String id;

  const AppActions({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(liveApplicationProvider(id));
    return (app != null)
        ? Container(
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
                    if (app.installed) {
                      final data = {
                        "uninstallTarget": app.getUninstallTarget()
                      };
                      _uninstallWorker(data);
                      ref.read(installedAppListProvider.notifier).refresh();
                    } else {
                      final data = {
                        "installTarget": app.getInstallTarget(),
                        "remote": app.remote!
                      };
                      ref.read(actionQueueProvider.notifier).add(
                          "Installing ${app.name ?? app.id}",
                          _installWorker,
                          data);
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.black),
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
          )
        : Container();
  }
}

Future<void> _installWorker(Map<String, String> data) async {
  Backend backend = getBackend();
  await Isolate.run(() {
    backend.installApplication(
        data["installTarget"] as String, data["remote"] as String);
  });
}

void _uninstallWorker(Map<String, String> data) {
  Backend backend = getBackend();
  Isolate.run(() {
    backend.uninstallApplication(data["uninstallTarget"] as String);
  });
}
