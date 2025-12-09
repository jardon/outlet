import '../core/action_queue.dart';
import '../core/logger.dart';
import '../providers/application_provider.dart';
import 'dart:collection';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionQueueNotifier extends AutoDisposeNotifier<ActionQueueStatus> {
  final Queue<Action> _queue = Queue();
  final List<String> _completedActions = [];
  Action? _currentAction;
  bool _isExecuting = false;

  @override
  ActionQueueStatus build() {
    return ActionQueueStatus(
      isIdle: true,
      currentActionTitle: null,
      queue: Queue<Action>.from(_queue),
      completedActions: List<String>.from(_completedActions),
    );
  }

  void _updateState() {
    state = ActionQueueStatus(
      isIdle: !_isExecuting,
      currentActionTitle: _currentAction?.title,
      queue: Queue<Action>.from(_queue),
      completedActions: List<String>.from(_completedActions),
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

    _completedActions.add(_currentAction!.appId);
    _currentAction = null;
    _isExecuting = false;
    _updateState();
  }

  bool isAppInQueue(String appId) {
    if (_isExecuting && _currentAction?.appId == appId) {
      return true;
    }
    return _queue.any((action) => action.appId == appId);
  }

  bool removeAction(String appId) {
    if (_isExecuting && _currentAction?.appId == appId) {
      logger.w("Cannot remove currently executing action for App ID: $appId");
      return false;
    }

    final int initialLength = _queue.length;
    _queue.removeWhere((action) => action.appId == appId);
    final bool removed = _queue.length < initialLength;

    if (removed) {
      logger.i("Removed action for App ID: $appId from queue.");
      _updateState();
    } else {
      logger.i("No pending action found for App ID: $appId to remove.");
    }
    return removed;
  }
}

final actionQueueProvider =
    AutoDisposeNotifierProvider<ActionQueueNotifier, ActionQueueStatus>(
  ActionQueueNotifier.new,
);

final isAppActionQueuedProvider = Provider.family<bool, String>((ref, appId) {
  ref.watch(actionQueueProvider);
  final notifier = ref.watch(actionQueueProvider.notifier);

  return notifier.isAppInQueue(appId);
});
