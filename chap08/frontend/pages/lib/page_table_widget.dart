import 'package:common/common.dart';
import 'package:flutter/material.dart';

class PageTableWidget extends StatelessWidget {
  const PageTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // header 应该有 2 个按钮，一个是添加按钮，一个是清除所有过滤器的按钮
    final header = [
      ElevatedButton(
        onPressed: () {},
        child: const Text('Add'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Clear All Filters'),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.end,
    );

    final columns = [
      DataColumn(
          label: [
        const Text('Name'),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_off).iconColor(Colors.grey),
        ),
      ].toRow()),
      DataColumn(
          label: [
        const Text('Name'),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt).iconColor(Colors.deepPurpleAccent),
        ),
      ].toRow()),
      const DataColumn(label: Text('Role')),
    ];
    final rows = [
      const DataRow(cells: [
        DataCell(Text('John')),
        DataCell(Text('28')),
        DataCell(Text('Software Engineer')),
      ]),
      const DataRow(cells: [
        DataCell(Text('Jane')),
        DataCell(Text('31')),
        DataCell(Text('Product Manager')),
      ]),
      const DataRow(cells: [
        DataCell(Text('Susan')),
        DataCell(Text('24')),
        DataCell(Text('Software Engineer')),
      ]),
    ];
    // 中间部分是一个 DataTable
    final content = DataTable(
      columns: columns,
      rows: rows,
    );
    final footer = [
      const Text('Total: 3 items'),
      const SizedBox(width: 16),
      const Text('Page: 1/1'),
      const SizedBox(width: 16),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.first_page),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.navigate_before),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.navigate_next),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.last_page),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.end,
    );
    return LayoutBuilder(
      builder: (context, constraints) => [
        header,
        content
            .constrained(minWidth: constraints.maxWidth)
            .scrollable()
            .expanded(),
        footer,
      ].toColumn(mainAxisSize: MainAxisSize.max),
    );
  }
}
