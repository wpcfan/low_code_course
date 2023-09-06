import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'date_input_widget.dart';

class DateRange {
  final DateTime? start;
  final DateTime? end;

  const DateRange({
    this.start,
    this.end,
  });

  @override
  String toString() {
    return 'DateRange{start: $start, end: $end}';
  }
}

class ColumnHeaderDateRangeFilterWidget extends StatefulWidget {
  final String headerLabel;
  final double? spacing;
  final bool isFilterable;
  final bool isFilterOn;
  final Color filterOnColor;
  final Color filterOffColor;
  final DateRange? filterValue;
  final Function(DateRange?)? onFilter;

  const ColumnHeaderDateRangeFilterWidget({
    super.key,
    required this.headerLabel,
    this.spacing,
    this.isFilterable = false,
    this.isFilterOn = false,
    this.filterOnColor = Colors.deepPurple,
    this.filterOffColor = Colors.grey,
    this.filterValue,
    this.onFilter,
  });

  @override
  State<ColumnHeaderDateRangeFilterWidget> createState() =>
      _ColumnHeaderDateRangeFilterWidgetState();
}

class _ColumnHeaderDateRangeFilterWidgetState
    extends State<ColumnHeaderDateRangeFilterWidget> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.filterValue?.start;
    _end = widget.filterValue?.end;
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.isFilterOn ? Icons.filter_alt : Icons.filter_alt_off;
    final iconColor =
        widget.isFilterOn ? widget.filterOnColor : widget.filterOffColor;
    final filterIcon = PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: [
              DateInputWidget(
                initialDate: _start,
                labelText: '开始日期',
                onDateSelected: (value) {
                  setState(() {
                    _start = value;
                  });
                },
              ),
              DateInputWidget(
                initialDate: _end,
                labelText: '结束日期',
                onDateSelected: (value) {
                  setState(() {
                    _end = value;
                  });
                },
              ),
            ].toColumn(),
          ),
          PopupMenuItem(
            child: [
              TextButton(
                onPressed: _handleConfirm,
                child: const Text('确认'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _start = null;
                    _end = null;
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
      onSelected: (value) {},
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

  // 校验日期范围是否有效
  bool _isDateRangeValid() {
    if (_start == null || _end == null) {
      return true;
    }
    return _start!.isBefore(_end!);
  }

  // 处理确认按钮点击
  void _handleConfirm() {
    if (_isDateRangeValid()) {
      widget.onFilter?.call(DateRange(start: _start, end: _end));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('结束日期必须晚于开始日期'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
