import 'block_config.dart';
import 'block_data.dart';
import 'category.dart';
import 'image_data.dart';
import 'product.dart';

/// 页面区块类型
/// - banner: 轮播图
/// - imageRow: 图片行
/// - productRow: 商品行
/// - waterfall: 瀑布流
enum PageBlockType {
  banner('banner'),
  imageRow('image_row'),
  productRow('product_row'),
  waterfall('waterfall'),
  unknown('unknown');

  final String value;
  const PageBlockType(this.value);
}

class PageBlock<T extends BlockData> {
  final BlockConfig config;
  final List<T> data;
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
        if (json['type'] == 'image_row' || json['type'] == 'banner') {
          return ImageData.fromJson(e as Map<String, dynamic>) as T;
        }
        if (json['type'] == 'product_row') {
          return Product.fromJson(e as Map<String, dynamic>) as T;
        }
        if (json['type'] == 'waterfall') {
          return Category.fromJson(e as Map<String, dynamic>) as T;
        }
        throw Exception('Unknown block type: ${json['type']}');
      }).toList(),
      type: PageBlockType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => PageBlockType.unknown,
      ),
    );
  }
}
