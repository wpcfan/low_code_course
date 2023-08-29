import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

import '../blocs/blocs.dart';
import 'load_more_widget.dart';
import 'sliver_app_bar.dart';
import 'sliver_list_body_widget.dart';

class ScaffoldBodyWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ScaffoldBodyWidget({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue,
          Colors.green,
        ],
      ),
    );
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case FetchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          default:
            return MyCustomScrollView(
              decoration: decoration,
              sliverAppBar: MySliverAppBar(
                decoration: decoration,
                onTap: () => context
                    .read<HomeBloc>()
                    .add(HomeOpenEndDrawerEvent(scaffoldKey: scaffoldKey)),
              ),
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
            ).material();
        }
      },
    );
  }
}
