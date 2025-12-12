import '../../core/application.dart';
import '../../providers/action_queue.dart';
import '../../providers/application_provider.dart';
import '../app_view.dart';
import '../navigation.dart';
import '../this_device.dart';
import 'app_icon_loader.dart';
import 'app_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';

class DownloadQueue extends ConsumerWidget {
  const DownloadQueue({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(actionQueueProvider);

    final title = status.currentActionTitle;
    final isIdle = status.isIdle;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45.0),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 15.0)
          ]),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(children: <Widget>[
            Container(
                height: 50.0,
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                alignment: Alignment.topLeft,
                // color: Colors.pink,
                child: Text(
                  !isIdle ? title! : "No downloads queued.",
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
              alignment: Alignment.topLeft,
              // color: Colors.green,
              child: !isIdle
                  ? LinearProgressIndicator(
                      // Arbitrary/Indeterminate progress
                      value: null,
                      backgroundColor: Colors.white38,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    )
                  : const Text(
                      "Install an application to add it to the queue.",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
            ))
          ])),
    );
  }
}

class CurrentDownload extends ConsumerWidget {
  const CurrentDownload({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(actionQueueProvider);

    final title = status.currentActionTitle;
    final appId = status.currentActionId;
    final isIdle = status.isIdle;

    Application? app;
    if (appId != null) {
      app = ref.watch(liveApplicationProvider(appId));
    }

    final Color color = fgColor(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 15.0)
          ]),
      child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            if (!isIdle && app != null) AppIconLoader(icon: app.icon),
            if (!isIdle && app != null) const SizedBox(width: 20),
            Expanded(
                child: Column(children: <Widget>[
              Container(
                  height: 50.0,
                  alignment: Alignment.topLeft,
                  child: Text(
                    !isIdle ? title! : "No downloads queued.",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Expanded(
                  child: Container(
                alignment: Alignment.topLeft,
                child: !isIdle
                    ? LinearProgressIndicator(
                        value: null,
                        borderRadius: BorderRadius.circular(5),
                      )
                    : const Text(
                        "Install an application to add it to the queue.",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
              ))
            ]))
          ])),
    );
  }
}

class PendingDownloads extends ConsumerWidget {
  const PendingDownloads({
    super.key,
  });

  @override
  build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(actionQueueProvider);

    final queue = status.queue;

    return Column(children: [
      if (queue.isNotEmpty)
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Text('Up next',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))),
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: queue.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          final app =
              ref.watch(liveApplicationProvider(queue.elementAt(index).appId));
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.push(
                context,
                NoAnimationPageRoute(
                  pageBuilder: (context, animation1, animation2) => Navigation(
                    title: "App Info",
                    child: AppView(app: app) as Widget,
                  ),
                ),
              );
            },
            child: PendingDownloadsItem(appId: queue.elementAt(index).appId),
          );
        },
      )
    ]);
  }
}

class PendingDownloadsItem extends ConsumerWidget {
  final String appId;

  const PendingDownloadsItem({
    super.key,
    required this.appId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionQueue = ref.watch(actionQueueProvider.notifier);
    final app = ref.watch(liveApplicationProvider(appId));

    final Color color = fgColor(context);

    return app != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Container(
              height: 100.0,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20.0)
                ],
              ),
              child: Row(spacing: 20, children: [
                AppIconLoader(icon: app.icon),
                Expanded(
                    child: Text(
                  app.name ?? app.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: 20.0,
                  tooltip: 'Remove item',
                  onPressed: () {
                    actionQueue.removeAction(app.id);
                  },
                ),
              ]),
            ))
        : Container();
  }
}

class CompletedDownloads extends ConsumerWidget {
  const CompletedDownloads({
    super.key,
  });

  @override
  build(BuildContext context, WidgetRef ref) {
    List<Application> apps = [];
    List<String> completedIds = ref.watch(actionQueueProvider).completedActions;

    for (var id in completedIds) {
      final app = ref.watch(liveApplicationProvider(id));
      if (app != null) {
        apps.add(app);
      }
    }

    return apps.isNotEmpty
        ? Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              alignment: AlignmentDirectional.centerStart,
              child: const Text(
                'Completed Downloads',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppList(
              apps: apps,
              shrinkWrap: true,
              details: false,
              scrollable: false,
            )
          ])
        : Container();
  }
}

class DownloadsFooterMessage extends StatelessWidget {
  const DownloadsFooterMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Looking for something?", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              NoAnimationPageRoute(
                pageBuilder: (context, animation1, animation2) =>
                    const Navigation(
                  title: "This Device",
                  child: ThisDevice(),
                ),
              ),
            );
          },
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.black)),
          child: const Text("Go to Installed Apps",
              style: TextStyle(
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
