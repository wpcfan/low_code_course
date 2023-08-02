import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class HomeState extends Equatable {
  final PageLayout? layout;
  final FetchStatus? status;
  final String? error;
  final List<Product> waterfallItems;
  final int page;
  const HomeState({
    this.layout,
    this.status,
    this.error,
    this.waterfallItems = const [],
    this.page = 1,
  });

  @override
  List<Object?> get props => [layout, status, error, waterfallItems, page];

  HomeState copyWith({
    PageLayout? layout,
    FetchStatus? status,
    String? error,
    List<Product>? waterfallItems,
    int? page,
  }) {
    return HomeState(
      layout: layout ?? this.layout,
      status: status ?? this.status,
      error: error ?? this.error,
      waterfallItems: waterfallItems ?? this.waterfallItems,
      page: page ?? this.page,
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
  PageBlock? get waterfallBlock =>
      blocks.firstWhere((block) => block.type == PageBlockType.waterfall);
}
