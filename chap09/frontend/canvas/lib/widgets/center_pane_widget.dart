import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

class CenterPaneWidget extends StatefulWidget {
  const CenterPaneWidget({super.key});

  @override
  State<CenterPaneWidget> createState() => _CenterPaneWidgetState();
}

class _CenterPaneWidgetState extends State<CenterPaneWidget> {
  final List<PageBlock> _blocks = [];
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAccept: (data) {
        if (data is PageBlock) {
          setState(() {
            _blocks.add(data);
          });
        }
      },
      builder: (context, candidateData, rejectedData) => ListView(
        children: _blocks.map((e) {
          const baselineScreenWidth = 400.0;
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
      ),
    );
  }
}
