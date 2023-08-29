import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'product_one_row_one_widget.dart';
import 'product_one_row_two_widget.dart';

/// 商品行组件
/// 用于展示一或两个商品
/// 可以通过 [BlockConfig] 参数来指定区块的宽度、高度、内边距、外边距等
/// 可以通过 [Product] 参数来指定商品列表
/// 可以通过 [addToCart] 参数来指定点击添加到购物车按钮时的回调
/// 可以通过 [onTap] 参数来指定点击商品卡片时的回调
class ProductRowWidget extends StatelessWidget {
  final List<Product> items;
  final BlockConfig config;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;
  const ProductRowWidget({
    super.key,
    required this.items,
    required this.config,
    this.addToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = config.horizontalSpacing ?? 0;
    final verticalSpacing = config.verticalSpacing ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final blockWidth = config.blockWidth ?? 0;
    final blockHeight = config.blockHeight ?? 0;
    final innerBlockWidth = blockWidth - 2 * horizontalPadding;
    final innerBlockHeight = blockHeight - 2 * verticalPadding;

    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(width: blockWidth, height: blockHeight);

    if (items.length == 1) {
      return ProductOneRowOneWidget(
        product: items.first,
        height: innerBlockHeight,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
        onTap: onTap,
        addToCart: addToCart,
      ).parent(page);
    }

    return items
        .map((e) => ProductOneRowTwoWidget(
              product: e,
              width: (innerBlockWidth - horizontalSpacing) / 2,
              height: innerBlockHeight,
              verticalSpacing: verticalSpacing,
              horizontalSpacing: horizontalSpacing,
              onTap: onTap,
              addToCart: addToCart,
            ).expanded())
        .toList()
        .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            separator: SizedBox(width: horizontalSpacing))
        .parent(page);
  }
}
