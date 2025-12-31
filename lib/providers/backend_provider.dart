import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/backends/backend.dart';

final backendProvider = Provider((ref) {
  return getBackend();
});
