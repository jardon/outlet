import '../backends/backend.dart';
import '../backends/flatpak_backend.dart';
import 'dart:io';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backendProvider = Provider((ref) {
  Map<String, String> env = Platform.environment;
  if (env['TEST_BACKEND_ENABLED'] != null) {
    return TestBackend();
  }

  if (env['FLATPAK_ENABLED'] != null) {
    return FlatpakBackend();
  }
  return TestBackend();
});
