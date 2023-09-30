import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:session_storage/session_storage.dart';

class NavBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  const NavBarWidget({
    super.key,
    this.title = '页面布局运营管理系统',
    this.backgroundColor = Colors.deepPurple,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
      actions: [
        // a popup menu can popup when hovering on the icon
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: '/profile',
                child: Text('修改个人信息'),
              ),
              const PopupMenuItem(
                value: '/languages',
                child: Text('选择语言'),
              ),
              const PopupMenuItem(
                value: '/themes',
                child: Text('选择主题'),
              ),
            ];
          },
          child: const Icon(Icons.settings),
          onSelected: (value) {
            context.go(value);
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            final session = SessionStorage();
            session.remove('token');
            context.go('/login');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
