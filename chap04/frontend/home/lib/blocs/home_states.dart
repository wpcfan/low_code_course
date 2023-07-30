import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class HomeState extends Equatable {
  final PageLayout? layout;
  final FetchStatus? status;
  final String? error;
  const HomeState({
    this.layout,
    this.status,
    this.error,
  });

  @override
  List<Object?> get props => [layout, status, error];

  HomeState copyWith({
    PageLayout? layout,
    FetchStatus? status,
    String? error,
  }) {
    return HomeState(
      layout: layout ?? this.layout,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  bool get hasError => error != null;
  bool get hasLayout => layout != null;
  bool get isInitial => status == FetchStatus.initial;
  bool get isLoading => status == FetchStatus.loading;
  bool get isLoaded => status == FetchStatus.success;
  bool get isFailed => status == FetchStatus.failure;

  List<PageBlock> get blocks => layout?.blocks ?? [];
  bool get isEmpty => blocks.isEmpty;
  PageConfig? get config => layout?.config;
}
