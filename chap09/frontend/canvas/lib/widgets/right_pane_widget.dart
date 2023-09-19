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
                      Center(
                        child: PageBlockConfigForm(
                          selectBlock: block!,
                        ),
                      ),
                      const Center(child: Text('数据内容')),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
