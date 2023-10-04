// run all tests: flutter test test/models_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'block_config_test.dart';
import 'page_block_test.dart';

void main() {
  group('BlockConfig', () {
    testBlockConfig();
  });
  group('PageBlock', () {
    testPageBlock();
  });
}
