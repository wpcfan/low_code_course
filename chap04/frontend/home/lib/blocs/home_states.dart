import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
  @override
  List<Object> get props => [];
}

class HomeLoadedState extends HomeState {
  final List<PageBlock> data;
  const HomeLoadedState(this.data);
  @override
  List<Object> get props => [data];
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class HomeEmptyState extends HomeState {
  const HomeEmptyState();
  @override
  List<Object> get props => [];
}

class HomeRefreshingState extends HomeState {
  const HomeRefreshingState();
  @override
  List<Object> get props => [];
}

class HomeRefreshedState extends HomeState {
  final List<PageBlock> data;
  const HomeRefreshedState(this.data);
  @override
  List<Object> get props => [data];
}

class HomeRefreshErrorState extends HomeState {
  final String message;
  const HomeRefreshErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class HomeLoadingMoreState extends HomeState {
  const HomeLoadingMoreState();
  @override
  List<Object> get props => [];
}

class HomeLoadedMoreState extends HomeState {
  final List<Product> data;
  const HomeLoadedMoreState(this.data);
  @override
  List<Object> get props => [data];
}

class HomeLoadMoreErrorState extends HomeState {
  final String message;
  const HomeLoadMoreErrorState(this.message);
  @override
  List<Object> get props => [message];
}
