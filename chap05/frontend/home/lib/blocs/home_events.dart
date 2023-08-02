import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeLoadEvent extends HomeEvent {
  const HomeLoadEvent();
  @override
  List<Object> get props => [];
}

class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();
  @override
  List<Object> get props => [];
}

class HomeLoadMoreEvent extends HomeEvent {
  const HomeLoadMoreEvent();
  @override
  List<Object> get props => [];
}
