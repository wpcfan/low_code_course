import 'package:common/common.dart';
import 'package:flutter/material.dart';

class SelectionModel<T> {
  final T value;
  final String label;
  const SelectionModel({
    required this.value,
    required this.label,
  });
}

class ColumnHeaderSelectionFilterWidget<T> extends StatefulWidget {
  final String headerLabel;
  final double? spacing;
  final bool isFilterable;
  final bool isFilterOn;
  final Color filterOnColor;
  final Color filterOffColor;
  final List<SelectionModel<T>> items;
  final Function(T?)? onFilter;
  final T? filterValue;
  const ColumnHeaderSelectionFilterWidget({
    super.key,
    required this.headerLabel,
    this.spacing = 8,
    this.isFilterable = false,
    this.isFilterOn = false,
    this.filterOnColor = Colors.deepPurpleAccent,
    this.filterOffColor = Colors.grey,
    this.onFilter,
    this.filterValue,
    this.items = const [],
  });

  @override
  State<ColumnHeaderSelectionFilterWidget<T>> createState() =>
      _ColumnHeaderSelectionFilterWidgetState<T>();
}

class _ColumnHeaderSelectionFilterWidgetState<T>
    extends State<ColumnHeaderSelectionFilterWidget<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.filterValue;
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.isFilterOn ? Icons.filter_alt : Icons.filter_alt_off;
    final iconColor =
        widget.isFilterOn ? widget.filterOnColor : widget.filterOffColor;
    final filterIcon = PopupMenuButton(
      itemBuilder: (context) {
        return [
          ...widget.items.map((item) {
            return PopupMenuItem(
              value: item.value,
              child: Text(item.label,
                  style: _selectedValue == item.value
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : null),
            );
          }),
          PopupMenuItem(
            child: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedValue = null;
                  });
                  widget.onFilter?.call(null);
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
      initialValue: _selectedValue,
      onSelected: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onFilter?.call(value);
      },
      child: Icon(icon).iconColor(iconColor),
    );
    return [
      Text(widget.headerLabel),
      if (widget.isFilterable) ...[
        SizedBox(width: widget.spacing),
        filterIcon,
      ]
    ].toRow();
  }
}
