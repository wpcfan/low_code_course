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
          pageBlocks.add(value);
        },
      ).constrained(
        width: 400,
      ),
      const RightPaneWidget().expanded(),
    ].toRow();
  }
}
