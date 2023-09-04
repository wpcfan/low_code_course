import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) => HomeBloc(
          pageRepository: PageRepository(),
          productRepository: ProductRepository())
        ..add(const HomeLoadEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == FetchStatus.refreshFailure ||
              state.status == FetchStatus.loadMoreFailure ||
              state.status == FetchStatus.failure) {
            _showLoadingMoreErrorMessage(context, state);
          }
        },
        child: Builder(builder: (context) {
          return Scaffold(
            key: key,
            body: ScaffoldBodyWidget(scaffoldKey: key),
            bottomNavigationBar: MyBottomBar(
                onTap: (index) => context
                    .read<HomeBloc>()
                    .add(HomeSwitchBottomNavigationEvent(index))),
            drawer: const LeftDrawer(),
            endDrawer: const RightDrawer(),
          );
        }),
      ),
    );
  }

  void _showLoadingMoreErrorMessage(BuildContext context, HomeState state) {
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
}
