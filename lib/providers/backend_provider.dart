import '../backends/backend.dart';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backendProvider = Provider((ref) {
  return getBackend();
});
