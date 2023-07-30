import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageRepository pageRepository;
  final ProductRepository productRepository;
  HomeBloc({required this.pageRepository, required this.productRepository})
      : super(const HomeState(status: FetchStatus.initial)) {
    on<HomeLoadEvent>(_onHomeLoadEvent);
    on<HomeRefreshEvent>(_onHomeRefreshEvent);
  }

  Future<void> _onHomeLoadEvent(
      HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final page = await pageRepository.getPageLayout(1);
      emit(state.copyWith(status: FetchStatus.success, layout: page));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onHomeRefreshEvent(
      HomeRefreshEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: FetchStatus.refreshing));
    try {
      final page = await pageRepository.getPageLayout(1);
      emit(state.copyWith(status: FetchStatus.success, layout: page));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.refreshFailure,
        error: e.toString(),
      ));
    }
  }
}
