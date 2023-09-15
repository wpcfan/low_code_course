import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ThemeSettingWidget extends StatelessWidget {
  const ThemeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择主题'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('深紫色'),
            onTap: () {
              context.go('/themes/deepPurple');
            },
          ),
          ListTile(
            title: const Text('蓝色'),
            onTap: () {
              context.go('/themes/blue');
            },
          ),
          ListTile(
            title: const Text('绿色'),
            onTap: () {
              context.go('/themes/green');
            },
          ),
          ListTile(
            title: const Text('橙色'),
            onTap: () {
              context.go('/themes/orange');
            },
          ),
          ListTile(
            title: const Text('红色'),
            onTap: () {
              context.go('/themes/red');
            },
          ),
        ],
      ),
    );
  }
}
