import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/page_table_widget.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/layouts',
    ),
    GoRoute(
      path: '/layouts',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Hello World'),
        ),
        body: const PageTableWidget(),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
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
        ]),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Hello World'),
        ),
        body: child,
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
      routes: [
        GoRoute(
          path: '/shells',
          builder: (context, state) => ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
                onTap: () {
                  context.go('/shells/$index');
                },
              );
            },
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => Center(
                child: Text('Shell ${state.pathParameters['id']}'),
              ),
            ),
          ],
        )
      ],
    )
  ],
);
void main() {
  /// 初始化 Bloc 的观察者，用于监听 Bloc 的生命周期
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
      ],
    );
  }
}
