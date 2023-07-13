import 'package:models/models.dart';

class PageBlock {
  final BlockConfig config;
  final List<ImageData> data;

  const PageBlock({
    required this.config,
    required this.data,
  });

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    return PageBlock(
      config: BlockConfig.fromJson(json['config'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => ImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
