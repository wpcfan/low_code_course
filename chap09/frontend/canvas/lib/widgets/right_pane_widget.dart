import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../forms/forms.dart';

class RightPaneWidget extends StatelessWidget {
  final PageBlock? block;
  const RightPaneWidget({
    super.key,
    this.block,
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
        return ImageDataForm(
          items: block!.data.map((e) => e as PageBlockData<ImageData>).toList(),
        );
      case PageBlockType.productRow:
        return ProductDataForm(
          items: block!.data.map((e) => e as PageBlockData<Product>).toList(),
        );
      case PageBlockType.waterfall:
        return WaterfallDataForm(
          items: block!.data.map((e) => e as PageBlockData<Category>).toList(),
        );
      default:
        return Container();
    }
  }
}
