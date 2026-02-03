import 'dart:isolate';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/backends/backend.dart';
import 'package:outlet/providers/action_queue.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/expandable_container.dart';
import 'package:outlet/views/components/theme.dart';

class AppUpdate extends ConsumerWidget {
  final String id;

  const AppUpdate({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(liveApplicationProvider(id));
    final actionQueue = ref.watch(actionQueueProvider.notifier);

    final Color color = fgColor(context);

    return (app != null)
        ? Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Row(spacing: 10, children: [
                  Text("Version ${app.releases.first.version ?? 'unknown'}"),
                  if (app.installed && app.current != true)
                    TextButton(
                      onPressed: () async {
                        final data = {"updateTarget": app.getUpdateTarget()};
                        actionQueue.add("Updating ${app.getLocalizedName()}",
                            app.id, _updateWorker, data);
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
                ExpandableContainer(
                    maxHeight: 100,
                    child: Html(
                        data: app.releases.first.description['C'] ??
                            'No release notes available.',
                        style: {
                          "h1": Style(
                            fontSize: FontSize.xxLarge,
                            textAlign: TextAlign.center,
                          ),
                          "p": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            lineHeight: const LineHeight(1.5),
                          ),
                          "ul": Style(
                            padding: HtmlPaddings.only(left: 20),
                            margin: Margins.only(top: 8, bottom: 8),
                          ),
                        })),
              ]),
            ),
          )
        : Container();
  }
}

Future<void> _updateWorker(Map<String, String> data) async {
  Backend backend = getBackend();
  await Isolate.run(() {
    backend.updateApplication(data["updateTarget"] as String);
  });
}
