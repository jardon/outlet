import 'dart:collection';
import 'logger.dart';

class ActionQueue {
  final Queue<Action> queue = Queue();
  Action? action;
  bool idle = true;

  void add(String title, Future<void> Function() action) {
    queue.add(Action(title: title, action: action));
    if (idle) execute();
  }

  Future<void> execute() async {
    idle = false;

    while (queue.isNotEmpty) {
      action = queue.removeFirst();
      try {
        if (action != null) {
          logger.i("Queueing action: ${action!.title}");
          await action!.action();
          logger.i("Action completed successfully.");
        }
      } catch (e) {
        logger.e("An error occured when processing task: $e");
      }
    }
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
