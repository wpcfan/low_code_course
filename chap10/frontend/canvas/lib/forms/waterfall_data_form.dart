import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../popups/popups.dart';

class WaterfallDataForm extends StatelessWidget {
  final List<PageBlockData<BlockData>> items;
  final Function(PageBlockData, PageBlockData)? onMove;
  final Function(PageBlockData)? onUpdate;
  final Function(PageBlockData)? onCreate;
  const WaterfallDataForm({
    super.key,
    this.items = const [],
    this.onMove,
    this.onUpdate,
    this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return [
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final result = await showSearch(
              context: context,
              delegate: CategorySearchDelegate(),
            );

            if (result != null) {
              onCreate?.call(PageBlockData(sort: 1, content: result));
            }
          },
          child: const Text('添加'),
        ),
        const Spacer()
      ].toColumn();
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final content = item.content as Category;
        return ListTile(
          title: Text(content.name ?? ''),
          subtitle: Text(content.code ?? ''),
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
            final result = await showSearch(
              context: context,
              delegate: CategorySearchDelegate(),
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
