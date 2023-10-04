import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void testBlockConfig() {
  group('BlockConfig', () {
    test('fromJson creates correct object', () {
      final Map<String, dynamic> json = {
        'horizontalPadding': 10.0,
        'verticalPadding': 20.0,
        'blockHeight': 100.0,
        'horizontalSpacing': 5.0,
        'verticalSpacing': 8.0,
        'blockWidth': 200.0,
      };

      final blockConfig = BlockConfig.fromJson(json);

      expect(blockConfig.horizontalPadding, 10.0);
      expect(blockConfig.verticalPadding, 20.0);
      expect(blockConfig.blockHeight, 100.0);
      expect(blockConfig.horizontalSpacing, 5.0);
      expect(blockConfig.verticalSpacing, 8.0);
      expect(blockConfig.blockWidth, 200.0);
    });

    test('fromJson handles null values', () {
      final Map<String, dynamic> json = {
        'horizontalPadding': null,
        'verticalPadding': null,
        'blockHeight': null,
        'horizontalSpacing': null,
        'verticalSpacing': null,
        'blockWidth': null,
      };

      final blockConfig = BlockConfig.fromJson(json);

      expect(blockConfig.horizontalPadding, null);
      expect(blockConfig.verticalPadding, null);
      expect(blockConfig.blockHeight, null);
      expect(blockConfig.horizontalSpacing, null);
      expect(blockConfig.verticalSpacing, null);
      expect(blockConfig.blockWidth, null);
    });

    test('toJson converts object to JSON correctly', () {
      const blockConfig = BlockConfig(
        horizontalPadding: 10.0,
        verticalPadding: 20.0,
        blockHeight: 100.0,
        horizontalSpacing: 5.0,
        verticalSpacing: 8.0,
        blockWidth: 200.0,
      );

      final json = blockConfig.toJson();

      expect(json['horizontalPadding'], 10.0);
      expect(json['verticalPadding'], 20.0);
      expect(json['blockHeight'], 100.0);
      expect(json['horizontalSpacing'], 5.0);
      expect(json['verticalSpacing'], 8.0);
      expect(json['blockWidth'], 200.0);
    });

    test('withRatio creates correct object', () {
      const blockConfig = BlockConfig(
        horizontalPadding: 10.0,
        verticalPadding: 20.0,
        blockHeight: 100.0,
        horizontalSpacing: 5.0,
        verticalSpacing: 8.0,
        blockWidth: 200.0,
      );

      final updatedBlockConfig = blockConfig.withRatio(2.0, 320.0);

      expect(updatedBlockConfig.horizontalPadding, 20.0);
      expect(updatedBlockConfig.verticalPadding, 40.0);
      expect(updatedBlockConfig.blockHeight, 200.0);
      expect(updatedBlockConfig.horizontalSpacing, 10.0);
      expect(updatedBlockConfig.verticalSpacing, 16.0);
      expect(updatedBlockConfig.blockWidth, 400.0);
    });

    test('copyWith creates a new object with updated values', () {
      const originalBlockConfig = BlockConfig(
        horizontalPadding: 10.0,
        verticalPadding: 20.0,
        blockHeight: 100.0,
        horizontalSpacing: 5.0,
        verticalSpacing: 8.0,
        blockWidth: 200.0,
      );

      final updatedBlockConfig = originalBlockConfig.copyWith(
        horizontalPadding: 15.0,
        verticalPadding: 25.0,
        blockHeight: 120.0,
        horizontalSpacing: 6.0,
        verticalSpacing: 9.0,
        blockWidth: 220.0,
      );

      expect(updatedBlockConfig.horizontalPadding, 15.0);
      expect(updatedBlockConfig.verticalPadding, 25.0);
      expect(updatedBlockConfig.blockHeight, 120.0);
      expect(updatedBlockConfig.horizontalSpacing, 6.0);
      expect(updatedBlockConfig.verticalSpacing, 9.0);
      expect(updatedBlockConfig.blockWidth, 220.0);
    });
  });
}
