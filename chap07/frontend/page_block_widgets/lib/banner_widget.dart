import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image_widget.dart';

/// 轮播图组件
/// 使用PageView实现
/// [items] 数据
/// [config] 区块配置
/// [onTap] 点击事件
/// [animationCurve] 动画曲线
/// [transitionDuration] 动画持续时间, 单位毫秒
/// [secondsToNextPage] 每隔多少秒，跳转到下一页
class BannerWidget extends StatefulWidget {
  final List<ImageData> items;
  final BlockConfig config;
  final void Function(MyLink?)? onTap;
  final Curve animationCurve;
  final int transitionDuration;
  final int secondsToNextPage;

  const BannerWidget({
    super.key,
    required this.items,
    required this.config,
    this.onTap,
    this.animationCurve = Curves.ease,
    this.transitionDuration = 500,
    this.secondsToNextPage = 5,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;

  /// 页面创建时，启动计时器
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer();
  }

  /// 页面销毁时，停止计时器
  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  /// 开始计时器
  void _startTimer() {
    if (widget.items.isEmpty) return;
    _timer =
        Timer.periodic(Duration(seconds: widget.secondsToNextPage), (timer) {
      /// 每隔一段时间，跳转到下一页
      /// 为了实现无限循环，需要对数据进行取模运算
      _nextPage((_currentPage + 1) % widget.items.length);
    });
  }

  /// 停止计时器
  void _stopTimer() {
    if (widget.items.isEmpty) return;
    _timer?.cancel();
    _timer = null;
  }

  /// 跳转到指定页
  void _nextPage(int page) {
    _pageController.animateToPage(
      page,

      /// 动画持续时间
      duration: Duration(milliseconds: widget.transitionDuration),

      /// 动画曲线
      curve: widget.animationCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockWidth = widget.config.blockWidth ?? 0;
    final blockHeight = widget.config.blockHeight ?? 0;
    final horizontalPadding = widget.config.horizontalPadding ?? 0;
    final verticalPadding = widget.config.verticalPadding ?? 0;

    /// 区块的样式
    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(width: blockWidth, height: blockHeight);

    final pageView = widget.items.isEmpty

        /// 如果没有数据，显示占位图
        ? const Placeholder()

        /// 如果有数据，使用PageView，可以支持以页的方式滑动
        : PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                /// 更新当前页
                _currentPage = index % widget.items.length;
              });
            },
            itemBuilder: (context, index) {
              /// 为了实现无限循环，需要对数据进行取模运算
              int idx = index % widget.items.length;
              return ImageWidget(
                imageUrl: widget.items[idx].image,
                width: blockWidth,
                height: blockHeight,
              ).gestures(
                onTap: () => widget.onTap?.call(widget.items[idx].link),
              );
            },
          );

    /// 指示器
    final indicators = List.generate(
      widget.items.length,
      (index) => const SizedBox(width: 8.0, height: 8.0)
          .decorated(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.grey[500],
          )
          .inkWell(onTap: () => _nextPage(index))
          .padding(horizontal: 4.0),
    )
        .toRow(mainAxisAlignment: MainAxisAlignment.center)
        .padding(bottom: 8.0)
        .alignment(Alignment.bottomCenter);

    /// 以 Stack 的方式将图片和指示器组合起来
    return [
      pageView.constrained(width: blockWidth, height: blockHeight),
      indicators,
    ].toStack().parent(page);
  }
}
