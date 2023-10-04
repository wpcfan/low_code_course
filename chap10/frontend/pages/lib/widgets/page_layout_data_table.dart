import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'column_header_date_range_filter_widget.dart';
import 'column_header_selection_filter_widget.dart';
import 'column_header_text_filter_widget.dart';

class PageLayoutDataTable extends StatelessWidget {
  final List<PageLayout> pageLayouts;
  final Function(int)? onSelect;
  final Function(PageLayout)? onEdit;
  final Function(PageLayout)? onDelete;
  final Function(PageLayout, DateTime, DateTime)? onPublish;
  final Function(PageLayout)? onDraft;
  final Function(String?)? onFilterTitle;
  final Function(Platform?)? onFilterPlatform;
  final Function(PageStatus?)? onFilterPageStatus;
  final Function(PageType?)? onFilterPageType;
  final Function(DateRange?)? onFilterStartTime;
  final Function(DateRange?)? onFilterEndTime;
  final PageQuery? query;

  const PageLayoutDataTable({
    super.key,
    this.pageLayouts = const [],
    this.onSelect,
    this.onEdit,
    this.onDelete,
    this.onPublish,
    this.onDraft,
    this.onFilterTitle,
    this.onFilterPlatform,
    this.onFilterPageStatus,
    this.onFilterPageType,
    this.onFilterStartTime,
    this.onFilterEndTime,
    this.query,
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
          filterValue: query?.title,
          onFilter: (value) => onFilterTitle?.call(value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderSelectionFilterWidget(
          headerLabel: '操作系统',
          isFilterable: true,
          filterValue: query?.platform,
          items: const [
            SelectionModel(value: Platform.app, label: 'APP'),
            SelectionModel(value: Platform.web, label: 'WEB'),
          ],
          onFilter: (value) => onFilterPlatform?.call(value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderSelectionFilterWidget(
          headerLabel: '布局状态',
          isFilterable: true,
          filterValue: query?.status,
          items: const [
            SelectionModel(value: PageStatus.archived, label: '已归档'),
            SelectionModel(value: PageStatus.draft, label: '草稿'),
            SelectionModel(value: PageStatus.published, label: '已发布'),
          ],
          onFilter: (value) => onFilterPageStatus?.call(value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderSelectionFilterWidget(
          headerLabel: '目标页面',
          isFilterable: true,
          filterValue: query?.pageType,
          items: const [
            SelectionModel(value: PageType.home, label: '首页'),
            SelectionModel(value: PageType.category, label: '分类页'),
            SelectionModel(value: PageType.about, label: '个人中心页'),
          ],
          onFilter: (value) => onFilterPageType?.call(value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderDateRangeFilterWidget(
          headerLabel: '生效时间',
          isFilterable: true,
          filterValue: query == null
              ? null
              : DateRange(
                  start: query!.startTimeFrom == null
                      ? null
                      : DateTime.parse(query!.startTimeFrom!),
                  end: query!.startTimeTo == null
                      ? null
                      : DateTime.parse(query!.startTimeTo!),
                ),
          onFilter: (value) => onFilterStartTime?.call(value),
        ),
      ),
      DataColumn(
        label: ColumnHeaderDateRangeFilterWidget(
          headerLabel: '失效时间',
          isFilterable: true,
          filterValue: query == null
              ? null
              : DateRange(
                  start: query!.endTimeFrom == null
                      ? null
                      : DateTime.parse(query!.endTimeFrom!),
                  end: query!.endTimeTo == null
                      ? null
                      : DateTime.parse(query!.endTimeTo!),
                ),
          onFilter: (value) => onFilterEndTime?.call(value),
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
        DataCell(TextButton(
          onPressed: () => onSelect?.call(pageLayout.id!),
          child: Text('${pageLayout.id}'),
        )),
        DataCell(Text(pageLayout.title ?? '')),
        DataCell(Text(pageLayout.platform.value)),
        DataCell(Text(pageLayout.status.value)),
        DataCell(Text(pageLayout.pageType.value)),
        DataCell(Text(pageLayout.startTime?.formatted ?? '')),
        DataCell(Text(pageLayout.endTime?.formatted ?? '')),
        DataCell(
          [
            IconButton(
              onPressed: () => onEdit?.call(pageLayout),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _handleDelete(context, pageLayout),
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => _handlePublish(context, pageLayout),
              icon: const Icon(Icons.publish),
            ),
            IconButton(
              onPressed: () => _handleDraft(context, pageLayout),
              icon: const Icon(Icons.download_for_offline),
            )
          ].toRow(),
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

  void _handlePublish(BuildContext context, PageLayout pageLayout) async {
    final result = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('zh'),
    );
    if (result != null) {
      onPublish?.call(pageLayout, result.start, result.end);
    }
  }

  void _handleDelete(BuildContext context, PageLayout pageLayout) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          title: '删除页面布局',
          content: '确定要删除页面布局吗？',
        );
      },
    );
    if (result) {
      onDelete?.call(pageLayout);
    }
  }

  void _handleDraft(BuildContext context, PageLayout pageLayout) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          title: '下线页面布局',
          content: '确定要下线页面布局吗？',
        );
      },
    );

    if (result) {
      onDraft?.call(pageLayout);
    }
  }
}
