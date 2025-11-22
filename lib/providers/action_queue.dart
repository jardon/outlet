import '../core/action_queue.dart';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actionQueueProvider = Provider((ref) {
  return ActionQueue();
});
