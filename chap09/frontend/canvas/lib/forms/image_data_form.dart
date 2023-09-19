import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../popups/popups.dart';

class ImageDataForm extends StatelessWidget {
  final List<PageBlockData<ImageData>> items;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onEdit;
  const ImageDataForm({
    super.key,
    this.items = const [],
    this.onMove,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.content.link.type.value),
          subtitle: Text(item.content.link.value),
          leading: Image.network(item.content.image),
          trailing: [
            Text(item.sort.toString()),
            [
              if (item.sort > 1)
                const Icon(Icons.arrow_upward).expanded().inkWell(
                  onTap: () {
                    onMove?.call(item, items[index - 1]);
                  },
                ),
              if (item.sort < items.length)
                const Icon(Icons.arrow_downward).expanded().inkWell(
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
                  imageData: item.content,
                );
              },
            );
            if (result != null) {
              onEdit?.call(item.copyWith(content: result));
            }
          },
        );
      },
    );
  }
}
