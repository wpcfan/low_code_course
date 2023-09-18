import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'widgets/widgets.dart';

class CanvasWidget extends StatelessWidget {
  final int pageLayoutId;
  const CanvasWidget({
    super.key,
    required this.pageLayoutId,
  });

  @override
  Widget build(BuildContext context) {
    final List<PageBlock> pageBlocks = [];
    return [
      const LeftPaneWidget().expanded(),
      CenterPaneWidget(
        blocks: pageBlocks,
        onBlockAdded: (value) {
          pageBlocks.add(value.copyWith(
            id: pageBlocks.length + 1,
          ));
        },
        onBlockMoved: (from, to) {
          final fromIndex =
              pageBlocks.indexWhere((element) => element.id == from.id);
          pageBlocks.removeAt(fromIndex);
          final toIndex =
              pageBlocks.indexWhere((element) => element.id == to.id);
          pageBlocks.insert(toIndex, from);
          pageBlocks.asMap().forEach((index, element) {
            pageBlocks[index] = element.copyWith(sort: index + 1);
          });
        },
      ).constrained(
        width: 400,
      ),
      const RightPaneWidget().expanded(),
    ].toRow();
  }
}
