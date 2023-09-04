import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/blocs/blocs.dart';
import 'package:models/models.dart';

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case FetchStatus.loadingMore:
            return state.hasReachedMax
                ? const SizedBox()
                : const Center(child: CircularProgressIndicator());
          default:
            return const SizedBox();
        }
      },
    );
  }
}
