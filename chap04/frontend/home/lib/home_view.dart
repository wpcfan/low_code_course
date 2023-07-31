import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/widgets/widgets.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
                return MyCustomScrollView(
                  loadMoreWidget: const LoadMoreWidget(),
                  sliver: const SliverListBodyWidget(),
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
