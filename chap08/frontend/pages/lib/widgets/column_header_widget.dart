import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ColumnHeaderWidget extends StatelessWidget {
  final String headerLabel;
  final double? spacing;
  final bool isFilterable;
  final bool isFilterOn;
  final Color filterOnColor;
  final Color filterOffColor;
  final Function()? onFilter;
  const ColumnHeaderWidget({
    super.key,
    required this.headerLabel,
    this.spacing = 8,
    this.isFilterable = false,
    this.isFilterOn = false,
    this.filterOnColor = Colors.deepPurpleAccent,
    this.filterOffColor = Colors.grey,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isFilterOn ? Icons.filter_alt : Icons.filter_alt_off;
    final iconColor = isFilterOn ? filterOnColor : filterOffColor;
    return [
      Text(headerLabel),
      if (isFilterable) ...[
        SizedBox(width: spacing),
        IconButton(
          onPressed: onFilter,
          icon: Icon(icon).iconColor(iconColor),
        ),
      ]
    ].toRow();
  }
}
