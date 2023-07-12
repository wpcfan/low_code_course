import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ImageRowWidget(
        items: [
          ImageData.fromJson({
            'imageUrl': 'https://picsum.photos/seed/1/200/300',
            'link': {
              'value': 'https://www.google.com',
              'type': 'url',
            },
          }),
          ImageData.fromJson({
            'imageUrl': 'https://picsum.photos/seed/2/200/300',
            'link': {
              'value': 'https://www.bing.com',
              'type': 'url',
            },
          })
        ],
        blockConfig: BlockConfig.fromJson({
          'blockHeight': 200.0,
          'horizontalPadding': 16.0,
          'verticalPadding': 8.0,
          'horozontalSpacing': 8.0,
        }),
        onTap: (link) => debugPrint(link.value),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
