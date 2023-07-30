import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageRepository pageRepository;
  final ProductRepository productRepository;
  HomeBloc({required this.pageRepository, required this.productRepository})
      : super(const HomeInitialState()) {
    on<HomeLoadEvent>(_onHomeLoadEvent);
  }

  Future<void> _onHomeLoadEvent(
      HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    try {
      final page = await pageRepository.getPageLayout(1);
      final data = page.blocks;
      if (data.isEmpty) {
        emit(const HomeEmptyState());
        return;
      }
      emit(HomeLoadedState(data));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
