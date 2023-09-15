import 'package:canvas/canvas.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/pages.dart';

import '../widgets/widgets.dart';

final GoRouter goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/layouts',
    ),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        appBar: const NavBarWidget(
          title: '页面布局运营管理系统',
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        // body should be a row of side menu and main content
        body: [
          if (MediaQuery.of(context).size.width > 600)
            const DrawerWidget(
              isFixed: true,
            ),
          child.expanded(flex: 4)
        ].toRow(),
        drawer: MediaQuery.of(context).size.width <= 600
            ? const DrawerWidget(
                isFixed: false,
              )
            : null,
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
      routes: [
        GoRoute(
          path: '/layouts',
          builder: (context, state) => PageTableWidget(
            onSelect: (id) => context.go('/layouts/$id'),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => CanvasWidget(
                  pageLayoutId: int.parse(state.pathParameters['id'] ?? '0')),
            ),
          ],
        ),
        GoRoute(
          path: '/playgrounds',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text('Hello World'),
            ),
            body: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                  onTap: () {
                    context.go('/playgrounds/$index');
                  },
                );
              },
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => Scaffold(
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: const Text('Hello World'),
                ),
                body: Center(
                  child: Text('Playground ${state.pathParameters['id']}'),
                ),
                // This trailing comma makes auto-formatting nicer for build methods.
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/themes',
          builder: (context, state) => const ThemeSettingWidget(),
          routes: [
            GoRoute(
              path: ':theme',
              builder: (context, state) {
                final theme = state.pathParameters['theme'];
                return Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: theme == 'deepPurple'
                          ? Colors.deepPurple
                          : theme == 'blue'
                              ? Colors.blue
                              : theme == 'green'
                                  ? Colors.green
                                  : theme == 'organge'
                                      ? Colors.orange
                                      : theme == 'red'
                                          ? Colors.red
                                          : Colors.deepPurple,
                    ),
                    useMaterial3: true,
                  ),
                  child: const ThemeSettingWidget(),
                );
              },
            ),
          ],
        )
      ],
    ),
  ],
);
