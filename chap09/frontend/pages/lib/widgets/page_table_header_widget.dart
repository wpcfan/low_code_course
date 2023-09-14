import 'package:common/common.dart';
import 'package:flutter/material.dart';

class PageTableHeaderWidget extends StatelessWidget {
  final Function()? onAdd;
  final Function()? onClearAllFilters;
  const PageTableHeaderWidget({
    super.key,
    this.onAdd,
    this.onClearAllFilters,
  });

  @override
  Widget build(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: onAdd,
        child: const Text('新增页面布局'),
      ),
      ElevatedButton(
        onPressed: onClearAllFilters,
        child: const Text('清除全部过滤器'),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
