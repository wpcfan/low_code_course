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
    /// 加载
    on<HomeLoadEvent>(_onHomeLoadEvent);

    /// 刷新
    on<HomeRefreshEvent>(_onHomeRefreshEvent);

    /// 加载更多
    on<HomeLoadMoreEvent>(_onHomeLoadMoreEvent);

    /// 切换底部导航
    on<HomeSwitchBottomNavigationEvent>(_onSwitchBottomNavigation);

    /// 打开抽屉
    on<HomeOpenEndDrawerEvent>(_onOpenEndDrawer);

    /// 关闭抽屉
    on<HomeCloseEndDrawerEvent>(_onCloseEndDrawer);
  }

  Future<void> _onHomeLoadEvent(
      HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final layout = await pageRepository.getPageLayout(1);
      if (layout.blocks.any((block) => block.type == PageBlockType.waterfall)) {
        final waterfallBlock = layout.blocks
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
          final hasReachedMax = waterfallItems.length < 4;
          emit(state.copyWith(
            status: FetchStatus.success,
            layout: layout,
            page: 1,
            waterfallItems: waterfallItems,
            hasReachedMax: hasReachedMax,
          ));
        }
        return;
      }
      emit(state.copyWith(
          status: FetchStatus.success,
          layout: layout,
          page: 1,
          hasReachedMax: true));
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
      final layout = await pageRepository.getPageLayout(1);
      if (layout.blocks.any((block) => block.type == PageBlockType.waterfall)) {
        final waterfallBlock = layout.blocks
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
          final hasReachedMax = waterfallItems.length < 4;
          emit(state.copyWith(
            status: FetchStatus.success,
            layout: layout,
            page: 1,
            waterfallItems: waterfallItems,
            hasReachedMax: hasReachedMax,
          ));
        }
        return;
      }
      emit(state.copyWith(
          status: FetchStatus.success,
          layout: layout,
          page: 1,
          hasReachedMax: true));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.refreshFailure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onHomeLoadMoreEvent(
      HomeLoadMoreEvent event, Emitter<HomeState> emit) async {
    if (state.waterfallBlock == null || state.hasReachedMax) return;
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
      final hasReachedMax = waterfallItems.length < 4;
      emit(state.copyWith(
        status: FetchStatus.success,
        waterfallItems: List.of(state.waterfallItems)..addAll(waterfallItems),
        page: hasReachedMax ? state.page : state.page + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.loadMoreFailure,
        error: e.toString(),
      ));
    }
  }

  void _onOpenEndDrawer(HomeOpenEndDrawerEvent event, Emitter<HomeState> emit) {
    event.scaffoldKey.currentState?.openEndDrawer();
    emit(state.copyWith(drawerOpen: true));
  }

  void _onCloseEndDrawer(
      HomeCloseEndDrawerEvent event, Emitter<HomeState> emit) {
    event.scaffoldKey.currentState?.closeEndDrawer();
    emit(state.copyWith(drawerOpen: false));
  }

  void _onSwitchBottomNavigation(
      HomeSwitchBottomNavigationEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
