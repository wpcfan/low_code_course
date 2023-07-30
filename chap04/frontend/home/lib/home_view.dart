import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:repositories/repositories.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'blocs/blocs.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = false;
  final List<Product> _products = [
    const Product(
      id: 1,
      name: 'Product 1',
      description: 'Product 1 description',
      price: '¥100.00',
      imageUrl: 'https://picsum.photos/seed/1/200/300',
    ),
    const Product(
      id: 2,
      name: 'Product 2',
      description: 'Product 2 description',
      price: '¥100.00',
      imageUrl: 'https://picsum.photos/seed/2/200/300',
    ),
    const Product(
      id: 3,
      name: 'Product 3',
      description: 'Product 3 description',
      price: '¥100.00',
      imageUrl: 'https://picsum.photos/seed/3/200/300',
    ),
    const Product(
      id: 4,
      name: 'Product 4',
      description: 'Product 4 description',
      price: '¥100.00',
      imageUrl: 'https://picsum.photos/seed/4/200/300',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const baseScreenWidth = 375.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final ratio = screenWidth / baseScreenWidth;

    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc(
            pageRepository: PageRepository(),
            productRepository: ProductRepository())
          ..add(const HomeLoadEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.status == FetchStatus.refreshFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? 'Error'),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeRefreshEvent());
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case FetchStatus.loading:
                return const Center(child: CircularProgressIndicator());
              default:
                final blocks = state.blocks;
                final waterfallItems = state.waterfallItems;
                final widgets = blocks.map((e) {
                  if (e.type == PageBlockType.imageRow) {
                    return SliverToBoxAdapter(
                      child: ImageRowWidget(
                        items: e.data.map((e) => e as ImageData).toList(),
                        config: e.config.withRatio(ratio),
                        onTap: (value) {
                          debugPrint('onTap: $value');
                        },
                      ),
                    );
                  } else if (e.type == PageBlockType.banner) {
                    return SliverToBoxAdapter(
                      child: BannerWidget(
                        items: e.data.map((e) => e as ImageData).toList(),
                        config: e.config.withRatio(ratio),
                        onTap: (value) {
                          debugPrint('onTap: $value');
                        },
                      ),
                    );
                  } else if (e.type == PageBlockType.productRow) {
                    return SliverToBoxAdapter(
                      child: ProductRowWidget(
                        items: e.data.map((e) => e as Product).toList(),
                        config: e.config.withRatio(ratio),
                        onTap: (value) {
                          debugPrint('onTap: $value');
                        },
                        addToCart: (value) => debugPrint('addToCart: $value'),
                      ),
                    );
                  } else if (e.type == PageBlockType.waterfall) {
                    return WaterfallWidget(
                      items: waterfallItems,
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
                return MyCustomScrollView(
                  loadMoreWidget:
                      _isLoading ? const CupertinoActivityIndicator() : null,
                  sliver: MultiSliver(
                    children: widgets,
                  ),
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeRefreshEvent());
                    await context.read<HomeBloc>().stream.firstWhere((state) =>
                        state.status == FetchStatus.success ||
                        state.status == FetchStatus.failure ||
                        state.status == FetchStatus.refreshFailure);
                  },
                  onLoadMore: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Future.delayed(const Duration(seconds: 4));
                    setState(() {
                      _products.addAll([
                        const Product(
                          id: 5,
                          name: 'Product 5',
                          description: 'Product 5 description',
                          price: '¥100.00',
                          imageUrl: 'https://picsum.photos/seed/5/200/300',
                        ),
                        const Product(
                          id: 6,
                          name: 'Product 6',
                          description: 'Product 6 description',
                          price: '¥100.00',
                          imageUrl: 'https://picsum.photos/seed/6/200/300',
                        ),
                        const Product(
                          id: 7,
                          name: 'Product 7',
                          description: 'Product 7 description',
                          price: '¥100.00',
                          imageUrl: 'https://picsum.photos/seed/7/200/300',
                        ),
                        const Product(
                          id: 8,
                          name: 'Product 8',
                          description: 'Product 8 description',
                          price: '¥100.00',
                          imageUrl: 'https://picsum.photos/seed/8/200/300',
                        ),
                      ]);
                      _isLoading = false;
                    });
                  },
                );
            }
          },
        ),
      ).material(),
    );
  }
}
