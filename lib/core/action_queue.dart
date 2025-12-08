import 'dart:collection';

class ActionQueueStatus {
  final bool isIdle;
  final String? currentActionTitle;
  final Queue<Action> queue;

  ActionQueueStatus({
    required this.isIdle,
    this.currentActionTitle,
    required this.queue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionQueueStatus &&
          runtimeType == other.runtimeType &&
          isIdle == other.isIdle &&
          currentActionTitle == other.currentActionTitle &&
          queue == other.queue;

  @override
  int get hashCode =>
      isIdle.hashCode ^ (currentActionTitle?.hashCode ?? 0) ^ queue.hashCode;
}

class Action {
  Action({
    required this.title,
    required this.appId,
    required this.action,
    required this.data,
  });

  final String title;
  final String appId;
  final Future<void> Function(Map<String, String>) action;
  final Map<String, String> data;
}
