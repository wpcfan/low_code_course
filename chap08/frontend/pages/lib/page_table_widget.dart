import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class PageTableWidget extends StatelessWidget {
  const PageTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // header 应该有 2 个按钮，一个是添加按钮，一个是清除所有过滤器的按钮
    const header = PageTableHeaderWidget();

    final columns = [
      const DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: 'Name',
          isFilterable: true,
        ),
      ),
      const DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: 'Age',
          isFilterable: true,
          isFilterOn: true,
        ),
      ),
      const DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: 'Role',
          isFilterable: true,
        ),
      ),
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
    const footer = PageTableFooterWidget(
      totalSize: 3,
      totalPage: 1,
      currentPage: 1,
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
