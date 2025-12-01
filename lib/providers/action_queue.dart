import '../core/action_queue.dart';
import '../core/logger.dart';
import 'dart:collection';
import 'dart:isolate';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionQueueNotifier extends AutoDisposeNotifier<ActionQueueStatus> {
  final Queue<Action> _queue = Queue();
  Action? _currentAction;
  bool _isExecuting = false;

  @override
  ActionQueueStatus build() {
    return ActionQueueStatus(
      isIdle: true,
      currentActionTitle: null,
      queueLength: 0,
    );
  }

  void _updateState() {
    state = ActionQueueStatus(
      isIdle: !_isExecuting,
      currentActionTitle: _currentAction?.title,
      queueLength: _queue.length,
    );
  }

  void add(String title, Future<void> Function() action) {
    logger.i("Queueing action: $title");
    _queue.add(Action(title: title, action: action));
    _updateState();

    if (!_isExecuting) {
      execute();
    }
  }

  Future<void> execute() async {
    if (_isExecuting) return;
    _isExecuting = true;

    while (_queue.isNotEmpty) {
      _currentAction = _queue.removeFirst();
      _updateState();

      try {
        if (_currentAction != null) {
          logger.i("Executing action: ${_currentAction!.title}");

          await Isolate.run(_currentAction!.action);

          logger.i("Action completed successfully.");
        }
      } catch (e) {
        logger.e("An error occured when processing task: $e");
      }
    }

    _currentAction = null;
    _isExecuting = false;
    _updateState();
  }
}

final actionQueueProvider =
    AutoDisposeNotifierProvider<ActionQueueNotifier, ActionQueueStatus>(
  ActionQueueNotifier.new,
);
