import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ThumbnailWidget extends StatelessWidget {
  final String imageSrc;
  final String label;

  const ThumbnailWidget({
    super.key,
    required this.imageSrc,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Image.network(
        imageSrc,
        fit: BoxFit.cover,
      ).expanded(),
      Text(label),
    ].toColumn();
  }
}
