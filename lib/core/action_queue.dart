class ActionQueueStatus {
  final bool isIdle;
  final String? currentActionTitle;
  final int queueLength;

  ActionQueueStatus({
    required this.isIdle,
    this.currentActionTitle,
    required this.queueLength,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionQueueStatus &&
          runtimeType == other.runtimeType &&
          isIdle == other.isIdle &&
          currentActionTitle == other.currentActionTitle &&
          queueLength == other.queueLength;

  @override
  int get hashCode =>
      isIdle.hashCode ^
      (currentActionTitle?.hashCode ?? 0) ^
      queueLength.hashCode;
}

class Action {
  Action({
    required this.title,
    required this.action,
  });

  final String title;
  final Future<void> Function() action;
}
