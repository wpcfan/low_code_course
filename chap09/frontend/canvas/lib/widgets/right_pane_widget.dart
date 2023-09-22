import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../constants.dart';
import '../forms/forms.dart';

class RightPaneWidget extends StatelessWidget {
  final PageBlock? block;
  final int bannerMinCount;
  final int bannerMaxCount;
  final Function(PageBlockData, PageBlockData)? onMoveData;
  final Function(PageBlockData)? onUpdateData;
  final Function(PageBlockData)? onDeleteData;
  final Function(PageBlock)? onUpdateBlock;
  const RightPaneWidget({
    super.key,
    this.block,
    this.bannerMinCount = Constants.defaultBannerImageMinCount,
    this.bannerMaxCount = Constants.defaultBannerImageMaxCount,
    this.onMoveData,
    this.onUpdateData,
    this.onDeleteData,
    this.onUpdateBlock,
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
                        onUpdate: onUpdateBlock,
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
          onMove: onMoveData,
          onUpdate: onUpdateData,
          items: items,
        );
      case PageBlockType.banner:
        return BannerDataForm(
          minimum: bannerMinCount,
          maximum: bannerMaxCount,
          onMove: onMoveData,
          onUpdate: onUpdateData,
          onDelete: onDeleteData,
          items: block!.data,
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
