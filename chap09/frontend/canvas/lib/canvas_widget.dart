import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'widgets/widgets.dart';

class CanvasWidget extends StatefulWidget {
  final int pageLayoutId;
  const CanvasWidget({
    super.key,
    required this.pageLayoutId,
  });

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  PageBlock? _selectedBlock;
  final List<PageBlock> pageBlocks = [];

  @override
  Widget build(BuildContext context) {
    const double baselineScreenWidth = 400.0;
    const double toolbarWidth = 40.0;
    return [
      const LeftPaneWidget().expanded(),
      CenterPaneWidget(
        blocks: pageBlocks,
        baselineScreenWidth: baselineScreenWidth,
        onBlockAdded: (value) {
          setState(() {
            pageBlocks.add(value.copyWith(
              id: pageBlocks.length + 1,
            ));
          });
        },
        onBlockMoved: (from, to) {
          setState(() {
            final fromIndex =
                pageBlocks.indexWhere((element) => element.id == from.id);
            pageBlocks.removeAt(fromIndex);
            final toIndex =
                pageBlocks.indexWhere((element) => element.id == to.id);
            pageBlocks.insert(toIndex, from);
            pageBlocks.asMap().forEach((index, element) {
              pageBlocks[index] = element.copyWith(sort: index + 1);
            });
          });
        },
        onBlockDeleted: (value) async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => const ConfirmDialog(
              title: '删除区块',
              content: '是否确认删除此区块？',
            ),
          );
        },
        onBlockEdited: (value) => setState(() {
          _selectedBlock = value;
        }),
      ).constrained(
        width: baselineScreenWidth + toolbarWidth,
      ),
      RightPaneWidget(block: _selectedBlock).expanded(),
    ].toRow();
  }
}
