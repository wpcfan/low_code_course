import 'package:models/page_block_data.dart';

import 'block_config.dart';
import 'block_data.dart';
import 'category.dart';
import 'enums/enums.dart';
import 'image_data.dart';
import 'product.dart';

class PageBlock {
  final int? id;
  final String? title;
  final int sort;
  final BlockConfig config;
  final List<PageBlockData<BlockData>> data;
  final PageBlockType type;

  const PageBlock({
    this.id,
    this.title,
    required this.sort,
    required this.config,
    required this.data,
    this.type = PageBlockType.unknown,
  });

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    return PageBlock(
      id: json['id'] as int?,
      title: json['title'] as String?,
      sort: json['sort'] as int,
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
      'id': id,
      'title': title,
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
      'type': type.value,
    };
  }

  @override
  String toString() {
    return 'PageBlock{id: $id, title: $title, sort: $sort, config: $config, data: $data, type: $type}';
  }

  PageBlock copyWith({
    int? id,
    String? title,
    int? sort,
    BlockConfig? config,
    List<PageBlockData<BlockData>>? data,
    PageBlockType? type,
  }) {
    return PageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }
}
