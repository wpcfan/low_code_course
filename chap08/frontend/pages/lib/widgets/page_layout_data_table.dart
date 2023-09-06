import 'package:common/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/page_layout.dart';

import 'column_header_widget.dart';

class PageLayoutDataTable extends StatelessWidget {
  final List<PageLayout> pageLayouts;
  final Function(PageLayout)? onEdit;
  final Function(PageLayout)? onDelete;
  final Function(PageLayout)? onPublish;
  final Function(PageLayout)? onDraft;
  final Function(String, String)? onFilter;
  const PageLayoutDataTable({
    super.key,
    this.pageLayouts = const [],
    this.onEdit,
    this.onDelete,
    this.onPublish,
    this.onDraft,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: 'Id',
          isFilterable: false,
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '标题',
          isFilterable: true,
          isFilterOn: true,
          onFilter: (value) => onFilter?.call('title', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '操作系统',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('platform', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '布局状态',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('status', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '目标页面',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('pageType', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '生效时间',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('startTime', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '失效时间',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('endTime', value),
        ),
      ),
      const DataColumn(
        label: ColumnHeaderWidget(
          headerLabel: '',
          isFilterable: false,
        ),
      ),
    ];
    final rows = pageLayouts.map((pageLayout) {
      final cells = [
        DataCell(Text('${pageLayout.id ?? 0}')),
        DataCell(Text(pageLayout.title)),
        DataCell(Text(pageLayout.platform.value)),
        DataCell(Text(pageLayout.status.value)),
        DataCell(Text(pageLayout.pageType.value)),
        DataCell(Text(pageLayout.startTime?.formatted ?? '')),
        DataCell(Text(pageLayout.endTime?.formatted ?? '')),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => onEdit?.call(pageLayout),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => onDelete?.call(pageLayout),
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () => onPublish?.call(pageLayout),
                icon: const Icon(Icons.publish),
              ),
              IconButton(
                onPressed: () => onDraft?.call(pageLayout),
                icon: const Icon(Icons.download_for_offline),
              )
            ],
          ),
        ),
      ];
      return DataRow(cells: cells);
    }).toList();
    // 中间部分是一个 DataTable
    final content = DataTable(
      columns: columns,
      rows: rows,
    );
    return content;
  }
}
