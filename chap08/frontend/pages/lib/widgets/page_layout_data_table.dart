import 'package:common/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'column_header_selection_filter_widget.dart';
import 'column_header_text_filter_widget.dart';

class PageLayoutDataTable extends StatelessWidget {
  final List<PageLayout> pageLayouts;
  final Function(PageLayout)? onEdit;
  final Function(PageLayout)? onDelete;
  final Function(PageLayout)? onPublish;
  final Function(PageLayout)? onDraft;
  final Function(String, Object?)? onFilter;
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
        label: ColumnHeaderTextFilterWidget(
          headerLabel: 'Id',
          isFilterable: false,
        ),
      ),
      DataColumn(
        label: ColumnHeaderTextFilterWidget(
          headerLabel: '标题',
          isFilterable: true,
          isFilterOn: true,
          onFilter: (value) => onFilter?.call('title', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderSelectionFilterWidget(
          headerLabel: '操作系统',
          isFilterable: true,
          items: const [
            SelectionModel(value: Platform.app, label: 'APP'),
            SelectionModel(value: Platform.web, label: 'WEB'),
          ],
          onFilter: (value) => onFilter?.call('platform', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderTextFilterWidget(
          headerLabel: '布局状态',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('status', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderTextFilterWidget(
          headerLabel: '目标页面',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('pageType', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderTextFilterWidget(
          headerLabel: '生效时间',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('startTime', value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderTextFilterWidget(
          headerLabel: '失效时间',
          isFilterable: true,
          onFilter: (value) => onFilter?.call('endTime', value),
        ),
      ),
      const DataColumn(
        label: ColumnHeaderTextFilterWidget(
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
