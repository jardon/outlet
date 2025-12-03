import '../../providers/action_queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
