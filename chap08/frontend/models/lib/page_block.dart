import 'package:models/page_block_data.dart';

import 'block_config.dart';
import 'block_data.dart';
import 'category.dart';
import 'enums/enums.dart';
import 'image_data.dart';
import 'product.dart';

class PageBlock {
  final BlockConfig config;
  final List<PageBlockData<BlockData>> data;
  final PageBlockType type;

  const PageBlock({
    required this.config,
    required this.data,
    this.type = PageBlockType.unknown,
  });

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    return PageBlock(
      config: BlockConfig.fromJson(json['config'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) {
        if (json['type'] == 'ImageRow' || json['type'] == 'Banner') {
          return PageBlockData<ImageData>.fromJson(
            e as Map<String, dynamic>,
            (json) => ImageData.fromJson(json),
          );
        }
        if (json['type'] == 'ProductRow') {
          return PageBlockData<Product>.fromJson(
            e as Map<String, dynamic>,
            (json) => Product.fromJson(json),
          );
        }
        if (json['type'] == 'Waterfall') {
          return PageBlockData<Category>.fromJson(
            e as Map<String, dynamic>,
            (json) => Category.fromJson(json),
          );
        }
        throw Exception('Unknown block type: ${json['type']}');
      }).toList(),
      type: PageBlockType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => PageBlockType.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
      'type': type.value,
    };
  }
}
