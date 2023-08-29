import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

/// 切换底部导航栏
class HomeSwitchBottomNavigationEvent extends HomeEvent {
  final int index;

  const HomeSwitchBottomNavigationEvent(this.index);

  @override
  List<Object> get props => [index];
}

/// 打开抽屉
class HomeOpenEndDrawerEvent extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeOpenEndDrawerEvent({required this.scaffoldKey});

  @override
  List<Object> get props => [scaffoldKey];
}

/// 关闭抽屉
class HomeCloseEndDrawerEvent extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeCloseEndDrawerEvent({required this.scaffoldKey});

  @override
  List<Object> get props => [scaffoldKey];
}
