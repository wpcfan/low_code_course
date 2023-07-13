import 'page_block.dart';
import 'page_config.dart';

class PageLayout {
  final List<PageBlock> blocks;
  final PageConfig config;

  const PageLayout({
    required this.blocks,
    required this.config,
  });

  factory PageLayout.fromJson(Map<String, dynamic> json) {
    return PageLayout(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => PageBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      config: PageConfig.fromJson(json['config'] as Map<String, dynamic>),
    );
  }
}
