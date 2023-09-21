import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../forms/forms.dart';

class RightPaneWidget extends StatelessWidget {
  final PageBlock? block;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onUpdate;
  const RightPaneWidget({
    super.key,
    this.block,
    this.onMove,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return block == null
        ? Container()
        : DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: '配置'),
                    Tab(text: '数据'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      PageBlockConfigForm(
                        selectBlock: block!,
                      ).center(),
                      _buildDataTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildDataTab() {
    switch (block?.type) {
      case PageBlockType.imageRow:
        final items = block!.data;
        return ImageDataForm(
          onMove: onMove,
          onUpdate: onUpdate,
          items: items,
        );
      case PageBlockType.productRow:
        return ProductDataForm(
          items: block!.data,
        );
      case PageBlockType.waterfall:
        return WaterfallDataForm(
          items: block!.data,
        );
      default:
        return Container();
    }
  }
}
