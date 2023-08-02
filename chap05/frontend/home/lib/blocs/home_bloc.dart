import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/category.dart';
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
    on<HomeLoadMoreEvent>(_onHomeLoadMoreEvent);
  }

  Future<void> _onHomeLoadEvent(
      HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final page = await pageRepository.getPageLayout(1);
      if (page.blocks.any((block) => block.type == PageBlockType.waterfall)) {
        final waterfallBlock = page.blocks
            .firstWhere((block) => block.type == PageBlockType.waterfall);
        final waterfallData =
            waterfallBlock.data.map((e) => e as Category).toList();
        if (waterfallData.isNotEmpty) {
          final category = waterfallData.first;

          final waterfallItems =
              await productRepository.getProductsByCategoryId(
            categoryId: category.id!,
            pageNum: 1,
            pageSize: 4,
          );
          emit(state.copyWith(
            status: FetchStatus.success,
            layout: page,
            waterfallItems: waterfallItems,
          ));
        }
        return;
      }
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

  Future<void> _onHomeLoadMoreEvent(
      HomeLoadMoreEvent event, Emitter<HomeState> emit) async {
    if (state.waterfallBlock == null) return;
    emit(state.copyWith(status: FetchStatus.loadingMore));
    try {
      final waterfallData =
          state.waterfallBlock!.data.map((e) => e as Category).toList();

      final category = waterfallData.first;

      final waterfallItems = await productRepository.getProductsByCategoryId(
        categoryId: category.id!,
        pageNum: state.page + 1,
        pageSize: 4,
      );
      emit(state.copyWith(
        status: FetchStatus.success,
        waterfallItems: [...state.waterfallItems, ...waterfallItems],
        page: state.page + 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.loadMoreFailure,
        error: e.toString(),
      ));
    }
  }
}
