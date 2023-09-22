import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

class CenterPaneWidget extends StatelessWidget {
  final List<PageBlock> blocks;
  final double baselineScreenWidth;
  final Function(PageBlock)? onBlockAdded;
  final Function(PageBlock, PageBlock)? onBlockMoved;
  final Function(PageBlock)? onBlockDeleted;
  final Function(PageBlock)? onBlockEdited;

  const CenterPaneWidget({
    super.key,
    required this.blocks,
    this.onBlockAdded,
    this.onBlockMoved,
    this.onBlockDeleted,
    this.onBlockEdited,
    this.baselineScreenWidth = 400.0,
  });

  @override
  Widget build(BuildContext context) {
    page(PageBlock block) => ({required Widget child}) => Draggable(
          data: block,
          feedback: child.opacity(0.6),
          childWhenDragging: child.decorated(
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          child: DragTarget(
            onWillAccept: (data) => data is PageBlock && data.id != null,
            onAccept: (data) {
              onBlockMoved?.call(data as PageBlock, block);
            },
            builder: (context, candidateData, rejectedData) {
              final toolbar = [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const ConfirmDialog(
                        title: '删除区块',
                        content: '是否确认删除此区块？',
                      ),
                    );
                    if (result == true) {
                      onBlockDeleted?.call(block);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onBlockEdited?.call(block),
                ),
              ].toColumn(
                mainAxisSize: MainAxisSize.min,
              );

              return [child, toolbar].toRow(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              );
            },
          ),
        );

    return DragTarget(
      onWillAccept: (data) => data is PageBlock && data.id == null,
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
              ).parent(page(e));
            } else if (e.type == PageBlockType.banner) {
              return BannerWidget(
                items: e.data.map((e) => e.content as ImageData).toList(),
                config: e.config.withRatio(1, baselineScreenWidth),
              ).parent(page(e));
            } else if (e.type == PageBlockType.productRow) {
              return ProductRowWidget(
                items: e.data.map((e) => e.content as Product).toList(),
                config: e.config.withRatio(1, baselineScreenWidth),
              ).parent(page(e));
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}
