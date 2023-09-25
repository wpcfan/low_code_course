import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductDataForm extends StatelessWidget {
  final List<PageBlockData<BlockData>> items;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onUpdate;
  const ProductDataForm({
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
        final content = item.content as Product;
        return ListTile(
          title: Text(content.name ?? ''),
          subtitle: Text(content.description ?? ''),
          leading: Image.network(
            content.images.first,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
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
          onTap: () async {},
        );
      },
    );
  }
}
