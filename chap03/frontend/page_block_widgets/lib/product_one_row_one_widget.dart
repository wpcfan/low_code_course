import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/image_widget.dart';

class ProductOneRowOneWidget extends StatelessWidget {
  final Product product;
  final BlockConfig config;

  const ProductOneRowOneWidget({
    super.key,
    required this.product,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = config.horozontalSpacing ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final blockWidth = config.blockWidth ?? 0;
    final blockHeight = config.blockHeight ?? 0;
    final innerBlockWidth = blockWidth - 2 * horizontalPadding;
    final innerBlockHeight = blockHeight - 2 * verticalPadding;

    // 左边是图片，图片是正方形，所以边长是 innerBlockHeight
    final left = ImageWidget(
      imageUrl: product.imageUrl ?? '',
      width: innerBlockHeight,
      height: innerBlockHeight,
    );

    final name = Text(
      product.name ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final desciption = Text(
      product.description ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );

    final price = Text(
      product.price ?? '',
      style: const TextStyle(
        fontSize: 16,
        color: Colors.red,
      ),
    );

    final cartBtn = ElevatedButton(
      onPressed: () {},
      child: const Text('加入购物车'),
    );

    final thirdRow = [
      price,
      cartBtn,
    ].toRow();

    final right = [
      name,
      desciption,
      thirdRow,
    ].toColumn();

    return [
      left,
      right,
    ].toRow();
  }
}
