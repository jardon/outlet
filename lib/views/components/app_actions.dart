import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/backends/backend.dart';
import 'package:outlet/providers/action_queue.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/theme.dart';

class AppActions extends ConsumerWidget {
  final String id;

  const AppActions({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(liveApplicationProvider(id));
    final actionQueue = ref.watch(actionQueueProvider.notifier);
    bool isQueued = false;

    if (app != null) {
      isQueued = ref.watch(isAppActionQueuedProvider(app.id));
    }

    String getInstallButtonText() {
      if (app != null) {
        if (app.installed) {
          return 'Uninstall';
        } else if (isQueued) {
          return 'Cancel';
        }
      }
      return 'Install';
    }

    final Color color = fgColor(context);

    return (app != null)
        ? Container(
            height: 70,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(spacing: 10, children: [
                TextButton(
                  onPressed: () async {
                    if (app.installed) {
                      final data = {
                        "uninstallTarget": app.getUninstallTarget()
                      };
                      await _uninstallWorker(data);
                      ref.read(installedAppListProvider.notifier).refresh();
                    } else if (isQueued) {
                      actionQueue.removeAction(app.id);
                    } else {
                      final data = {
                        "installTarget": app.getInstallTarget(),
                        "remote": app.remote!
                      };
                      actionQueue.add("Installing ${app.name}", app.id,
                          _installWorker, data);
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.black),
                  ),
                  child: Text(getInstallButtonText(),
                      style: const TextStyle(color: Colors.white)),
                ),
                if (app.installed)
                  TextButton(
                    onPressed: () async {
                      var launch = app.launchCommand();
                      await Process.start(
                        launch.split(' ').first,
                        launch.split(' ').sublist(1),
                        mode: ProcessStartMode.detached,
                      );
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Text("Open",
                        style: TextStyle(color: Colors.white)),
                  ),
                if (app.installed && app.current != true)
                  TextButton(
                    onPressed: () async {
                      final data = {"updateTarget": app.getUpdateTarget()};
                      actionQueue.add(
                          "Updating ${app.name}", app.id, _updateWorker, data);
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Text("Update",
                        style: TextStyle(color: Colors.white)),
                  ),
                Expanded(child: Container()),
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

Future<void> _uninstallWorker(Map<String, String> data) async {
  Backend backend = getBackend();
  await Isolate.run(() {
    backend.uninstallApplication(data["uninstallTarget"] as String);
  });
}

Future<void> _updateWorker(Map<String, String> data) async {
  Backend backend = getBackend();
  await Isolate.run(() {
    backend.updateApplication(data["updateTarget"] as String);
  });
}
