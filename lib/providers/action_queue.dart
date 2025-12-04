import '../core/action_queue.dart';
import '../core/logger.dart';
import '../providers/application_provider.dart';
import 'dart:collection';
import 'dart:core';
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

  Future<void> add(
      String title,
      String appId,
      Future<void> Function(Map<String, String>) action,
      Map<String, String> data) async {
    logger.i("Queueing action: $title");
    _queue.add(Action(title: title, appId: appId, action: action, data: data));
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

          await _currentAction!.action(_currentAction!.data);

          logger.i("Action completed successfully.");
        }
      } catch (e) {
        logger.e("An error occured when processing task: $e");
      }
      ref.read(installedAppListProvider.notifier).refresh();
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
