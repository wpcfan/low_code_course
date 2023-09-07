import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ColumnHeaderTextFilterWidget extends StatelessWidget {
  final String headerLabel;
  final double? spacing;
  final bool isFilterable;
  final Color filterOnColor;
  final Color filterOffColor;
  final String? filterValue;
  final Function(String)? onFilter;
  const ColumnHeaderTextFilterWidget({
    super.key,
    required this.headerLabel,
    this.spacing = 8,
    this.isFilterable = false,
    this.filterOnColor = Colors.deepPurpleAccent,
    this.filterOffColor = Colors.grey,
    this.onFilter,
    this.filterValue,
  });

  @override
  Widget build(BuildContext context) {
    final isFilterOn =
        isFilterable && filterValue != null && filterValue!.isNotEmpty;
    final icon = isFilterOn ? Icons.filter_alt : Icons.filter_alt_off;
    final iconColor = isFilterOn ? filterOnColor : filterOffColor;
    final controller = TextEditingController(text: filterValue);
    final filterIcon = PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入关键字',
              border: OutlineInputBorder(),
            ),
          )),
          PopupMenuItem(
            child: [
              TextButton(
                onPressed: () {
                  onFilter?.call(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('确认'),
              ),
              TextButton(
                onPressed: () {
                  controller.text = '';
                  onFilter?.call('');
                  Navigator.pop(context);
                },
                child: const Text('清除'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
            ].toRow(),
          ),
        ];
      },
      onSelected: (value) {},
      child: Icon(icon).iconColor(iconColor),
    );
    return [
      Text(headerLabel),
      if (isFilterable) ...[
        SizedBox(width: spacing),
        filterIcon,
      ]
    ].toRow();
  }
}
