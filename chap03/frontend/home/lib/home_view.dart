import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const baseScreenWidth = 375.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final ratio = screenWidth / baseScreenWidth;
    final pageLayout = PageLayout.fromJson({
      'config': {
        'baseScreenWidth': baseScreenWidth,
      },
      'blocks': [
        {
          'type': 'banner',
          'config': {
            'blockHeight': 120.0,
            'horizontalPadding': 8.0,
            'verticalPadding': 8.0,
            'horozontalSpacing': 8.0,
            'blockWidth': baseScreenWidth,
          },
          'data': [
            {
              'imageUrl': 'https://picsum.photos/seed/1/200/300',
              'link': {
                'value': 'https://www.google.com',
                'type': 'url',
              },
            },
            {
              'imageUrl': 'https://picsum.photos/seed/2/200/300',
              'link': {
                'value': 'https://www.bing.com',
                'type': 'url',
              },
            },
            {
              'imageUrl': 'https://picsum.photos/seed/3/200/300',
              'link': {
                'value': 'https://www.baidu.com',
                'type': 'url',
              },
            },
            {
              'imageUrl': 'https://picsum.photos/seed/4/200/300',
              'link': {
                'value': 'https://www.baidu.com',
                'type': 'url',
              },
            }
          ],
        },
        {
          'type': 'image_row',
          'config': {
            'blockHeight': 200.0,
            'horizontalPadding': 16.0,
            'verticalPadding': 8.0,
            'horozontalSpacing': 8.0,
            'blockWidth': baseScreenWidth,
          },
          'data': [
            {
              'imageUrl': 'https://picsum.photos/seed/1/200/300',
              'link': {
                'value': 'https://www.google.com',
                'type': 'url',
              },
            },
            {
              'imageUrl': 'https://picsum.photos/seed/2/200/300',
              'link': {
                'value': 'https://www.bing.com',
                'type': 'url',
              },
            },
            {
              'imageUrl': 'https://picsum.photos/seed/3/200/300',
              'link': {
                'value': 'https://www.baidu.com',
                'type': 'url',
              },
            },
          ],
        },
        {
          'type': 'product_row',
          'config': {
            'blockHeight': 120.0,
            'horizontalPadding': 16.0,
            'verticalPadding': 8.0,
            'horozontalSpacing': 8.0,
            'verticalSpacing': 4.0,
            'blockWidth': baseScreenWidth,
          },
          'data': [
            {
              'id': 1,
              'name':
                  'Product 1 very very very very very very very very very very long',
              'description':
                  'Product 1 description very very very very very very very very very very long',
              'price': '¥100.00',
              'imageUrl': 'https://picsum.photos/seed/1/200/300',
            }
          ]
        },
        {
          'type': 'product_row',
          'config': {
            'blockHeight': 300.0,
            'horizontalPadding': 16.0,
            'verticalPadding': 8.0,
            'horozontalSpacing': 8.0,
            'verticalSpacing': 4.0,
            'blockWidth': baseScreenWidth,
          },
          'data': [
            {
              'id': 1,
              'name':
                  'Product 1 very very very very very very very very very very long',
              'description':
                  'Product 1 description very very very very very very very very very very long',
              'price': '¥100.00',
              'imageUrl': 'https://picsum.photos/seed/1/200/300',
            },
            {
              'id': 2,
              'name': 'Product 2',
              'description': 'Product 2 description',
              'price': '¥100.00',
              'imageUrl': 'https://picsum.photos/seed/2/200/300',
            },
          ]
        }
      ]
    });
    final blocks = pageLayout.blocks;
    final widgets = blocks.map((e) {
      if (e.type == PageBlockType.imageRow) {
        return ImageRowWidget(
          items: e.data.map((e) => e as ImageData).toList(),
          config: e.config.withRatio(ratio),
          onTap: (value) {
            debugPrint('onTap: $value');
          },
        );
      } else if (e.type == PageBlockType.banner) {
        return BannerWidget(
          items: e.data.map((e) => e as ImageData).toList(),
          config: e.config.withRatio(ratio),
          onTap: (value) {
            debugPrint('onTap: $value');
          },
        );
      } else if (e.type == PageBlockType.productRow) {
        return ProductRowWidget(
          items: e.data.map((e) => e as Product).toList(),
          config: e.config.withRatio(ratio),
          onTap: (value) {
            debugPrint('onTap: $value');
          },
          addToCart: (value) => debugPrint('addToCart: $value'),
        );
      } else {
        return Container();
      }
    }).toList();
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     title: Text(widget.title),
    //   ),
    //   body: widgets
    //       .toColumn(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //       )
    //       .scrollable(),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ),
    // );
    return MyCustomScrollView(
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          widgets,
        ),
      ),
      onRefresh: () => Future.delayed(const Duration(seconds: 1)),
    ).material();
  }
}
