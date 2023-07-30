import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:repositories/repositories.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'blocs/blocs.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                  loadMoreWidget: state.isLoadingMore
                      ? const CupertinoActivityIndicator()
                      : null,
                  sliver: MultiSliver(
                    children: widgets,
                  ),
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeRefreshEvent());
                    await context.read<HomeBloc>().stream.firstWhere((state) =>
                        state.status == FetchStatus.success ||
                        state.status == FetchStatus.refreshFailure);
                  },
                  onLoadMore: () async {
                    context.read<HomeBloc>().add(const HomeLoadMoreEvent());
                    await context.read<HomeBloc>().stream.firstWhere((state) =>
                        state.status == FetchStatus.success ||
                        state.status == FetchStatus.loadMoreFailure);
                  },
                );
            }
          },
        ),
      ).material(),
    );
  }
}
