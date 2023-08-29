import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class HomeState extends Equatable {
  final PageLayout? layout;
  final FetchStatus? status;
  final String? error;
  final List<Product> waterfallItems;
  final int page;
  final int selectedIndex;
  final bool hasReachedMax;
  final bool drawerOpen;
  const HomeState({
    this.layout,
    this.status,
    this.error,
    this.waterfallItems = const [],
    this.page = 1,
    this.selectedIndex = 0,
    this.drawerOpen = false,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
        layout,
        status,
        error,
        waterfallItems,
        page,
        selectedIndex,
        drawerOpen,
        hasReachedMax,
      ];

  HomeState copyWith({
    PageLayout? layout,
    FetchStatus? status,
    String? error,
    List<Product>? waterfallItems,
    int? page,
    int? selectedIndex,
    bool? drawerOpen,
    bool? hasReachedMax,
  }) {
    return HomeState(
      layout: layout ?? this.layout,
      status: status ?? this.status,
      error: error ?? this.error,
      waterfallItems: waterfallItems ?? this.waterfallItems,
      page: page ?? this.page,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      drawerOpen: drawerOpen ?? this.drawerOpen,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  bool get hasError => error != null;
  bool get hasLayout => layout != null;
  bool get isInitial => status == FetchStatus.initial;
  bool get isLoading => status == FetchStatus.loading;
  bool get isLoaded => status == FetchStatus.success;
  bool get isFailed => status == FetchStatus.failure;
  bool get isLoadingMore => status == FetchStatus.loadingMore;

  List<PageBlock> get blocks => layout?.blocks ?? [];
  bool get isEmpty => blocks.isEmpty;
  PageConfig? get config => layout?.config;
  bool get hasWaterfallBlock =>
      blocks.any((block) => block.type == PageBlockType.waterfall);
  PageBlock? get waterfallBlock => blocks
      .where((block) => block.type == PageBlockType.waterfall)
      .firstOrNull;
}
