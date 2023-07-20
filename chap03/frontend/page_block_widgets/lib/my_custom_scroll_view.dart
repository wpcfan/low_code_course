import 'package:flutter/material.dart';

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          // 检查是否滚动到底部
          if (metrics.pixels == metrics.maxScrollExtent) {
            print('滚动到底部');
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('SliverAppBar'),
            floating: true,
            flexibleSpace: Placeholder(),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item $index'),
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
