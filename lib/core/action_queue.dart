import 'dart:collection';
import 'dart:isolate';
import 'logger.dart';

class ActionQueue {
  final Queue<Action> queue = Queue();
  Action? action;
  bool idle = true;

  void add(String title, Future<void> Function() action) async {
    logger.i("Queueing action: $title");
    queue.add(Action(title: title, action: action));
    if (idle) execute();
  }

  Future<void> execute() async {
    idle = false;

    while (queue.isNotEmpty) {
      action = queue.removeFirst();
      try {
        if (action != null) {
          logger.i("Executing action: ${action!.title}");
          await Isolate.run(action!.action);
          logger.i("Action completed successfully.");
        }
      } catch (e) {
        logger.e("An error occured when processing task: $e");
      }
    }
    action = null;
    idle = true;
  }
}

class Action {
  Action({
    required this.title,
    required this.action,
  });

  final String title;
  final Future<void> Function() action;
}
