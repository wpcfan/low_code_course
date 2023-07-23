import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:models/models.dart';

import 'product_one_row_two_widget.dart';

class WaterfallWidget extends StatelessWidget {
  final List<Product> items;
  final BlockConfig config;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;
  const WaterfallWidget({
    super.key,
    required this.items,
    required this.config,
    this.addToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = config.horozontalSpacing ?? 0;
    final verticalSpacing = config.verticalSpacing ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final blockWidth = config.blockWidth ?? 0;
    final blockHeight = config.blockHeight ?? 0;
    final innerBlockWidth = blockWidth - 2 * horizontalPadding;
    final innerBlockHeight = blockHeight - 2 * verticalPadding;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: horizontalSpacing,
        mainAxisSpacing: verticalSpacing,
        childCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return ProductOneRowTwoWidget(
            product: product,
            width: (innerBlockWidth - horizontalSpacing) / 2,
            height: innerBlockHeight,
            verticalSpacing: verticalSpacing,
            horizontalSpacing: horizontalSpacing,
            onTap: onTap,
            addToCart: addToCart,
          );
        },
      ),
    );
  }
}
