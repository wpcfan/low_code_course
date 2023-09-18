import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

class CenterPaneWidget extends StatelessWidget {
  final List<PageBlock> blocks;
  final double baselineScreenWidth;
  final Function(PageBlock)? onBlockAdded;
  const CenterPaneWidget({
    super.key,
    required this.blocks,
    this.onBlockAdded,
    this.baselineScreenWidth = 400.0,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (data) => data is PageBlock,
      onAccept: (data) {
        onBlockAdded?.call(data as PageBlock);
      },
      builder: (context, candidateData, rejectedData) {
        return ListView(
          children: blocks.map((e) {
            if (e.type == PageBlockType.imageRow) {
              return ImageRowWidget(
                items: e.data.map((e) => e.content as ImageData).toList(),
                config: e.config.withRatio(1, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
              );
            } else if (e.type == PageBlockType.banner) {
              return BannerWidget(
                items: e.data.map((e) => e.content as ImageData).toList(),
                config: e.config.withRatio(1, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
              );
            } else if (e.type == PageBlockType.productRow) {
              return ProductRowWidget(
                items: e.data.map((e) => e.content as Product).toList(),
                config: e.config.withRatio(1, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
                addToCart: (value) => debugPrint('addToCart: $value'),
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}
