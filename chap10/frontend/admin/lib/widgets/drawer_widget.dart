import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatelessWidget {
  final bool isFixed;
  const DrawerWidget({
    super.key,
    this.isFixed = false,
  });

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      padding: isFixed ? const EdgeInsets.all(16) : EdgeInsets.zero,
      children: [
        if (!isFixed)
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('Drawer Header', style: TextStyle(color: Colors.white)),
          ),
        ListTile(
          title: [
            const Icon(
              Icons.document_scanner,
            ),
            const SizedBox(width: 8),
            const Text('页面布局列表'),
          ].toRow(),
          onTap: () {
            context.go('/layouts');
          },
        ),
        ListTile(
          title: [
            const Icon(
              Icons.play_circle,
            ),
            const SizedBox(width: 8),
            const Text('操练场'),
          ].toRow(),
          onTap: () {
            context.go('/playgrounds');
          },
        ),
        ListTile(
          title: [
            const Icon(
              Icons.settings,
            ),
            const SizedBox(width: 8),
            const Text('设置主题'),
          ].toRow(),
          onTap: () {
            context.go('/themes');
          },
        ),
      ],
    );
    return isFixed
        ? list
            .decorated(
              color: Colors.grey[200],
            )
            .expanded()
        : Drawer(
            child: list,
          );
  }
}
