import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../popups/popups.dart';

class ImageDataForm extends StatelessWidget {
  final List<PageBlockData<BlockData>> items;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onUpdate;
  const ImageDataForm({
    super.key,
    this.items = const [],
    this.onMove,
    this.onUpdate,
  });

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
            ].toColumn(mainAxisSize: MainAxisSize.min)
          ].toRow(mainAxisSize: MainAxisSize.min),
          onTap: () async {
            final result = await showDialog<ImageData>(
              context: context,
              builder: (context) {
                return EditImageDataWidget(
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
