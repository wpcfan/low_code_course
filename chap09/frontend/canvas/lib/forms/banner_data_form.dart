import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../constants.dart';
import '../popups/popups.dart';

class BannerDataForm extends StatelessWidget {
  final List<PageBlockData<BlockData>> items;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onUpdate;
  final Function(PageBlockData)? onDelete;
  final int minimum;
  final int maximum;
  const BannerDataForm({
    super.key,
    this.items = const [],
    this.onMove,
    this.onUpdate,
    this.onDelete,
    this.minimum = Constants.defaultBannerImageMinCount,
    this.maximum = Constants.defaultBannerImageMaxCount,
  }) : assert(minimum >= Constants.defaultBannerImageMinCount &&
            maximum <= Constants.defaultBannerImageMaxCount);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final content = item.content as ImageData;
        return ListTile(
          title: Text(content.link.type.value),
          subtitle: Text(content.link.value),
          leading: Image.network(content.image),
          trailing: [
            Text(item.sort.toString()),
            const SizedBox(width: 10),
            [
              if (item.sort > 1)
                const Icon(Icons.arrow_upward).inkWell(
                  onTap: () {
                    onMove?.call(item, items[index - 1]);
                  },
                ),
              if (item.sort < items.length)
                const Icon(Icons.arrow_downward).inkWell(
                  onTap: () {
                    onMove?.call(item, items[index + 1]);
                  },
                ),
            ].toColumn(mainAxisSize: MainAxisSize.min),
            const SizedBox(width: 10),
            const Icon(Icons.delete).inkWell(
              onTap: () async {
                if (items.length <= minimum) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('至少需要 $minimum 个'),
                    ),
                  );
                  return;
                }
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return const ConfirmDialog(
                      title: '删除',
                      content: '确定要删除吗？',
                    );
                  },
                );

                if (result == true) {
                  onDelete?.call(item);
                }
              },
            ),
          ].toRow(mainAxisSize: MainAxisSize.min),
          onTap: () async {
            final result = await showDialog<ImageData>(
              context: context,
              builder: (context) {
                return CreateOrUpdateImageDataWidget(
                  imageData: content,
                );
              },
            );
            if (result != null) {
              onUpdate?.call(item.copyWith(content: result));
            }
          },
        );
      },
    );
  }
}
