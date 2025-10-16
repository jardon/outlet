import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backends/backend.dart';

final appListProvider = Provider((ref) {
  return TestBackend().data.values.toList();
});
