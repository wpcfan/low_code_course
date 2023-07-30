import 'page_block.dart';
import 'page_config.dart';

class PageLayout {
  final int? id;
  final List<PageBlock> blocks;
  final PageConfig config;

  const PageLayout({
    this.id,
    required this.blocks,
    required this.config,
  });

  factory PageLayout.fromJson(Map<String, dynamic> json) {
    return PageLayout(
      id: json['id'] as int?,
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => PageBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      config: PageConfig.fromJson(json['config'] as Map<String, dynamic>),
    );
  }
}
