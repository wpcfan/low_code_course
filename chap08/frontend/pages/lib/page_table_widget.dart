import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'popups/popups.dart';
import 'widgets/widgets.dart';

class PageTableWidget extends StatelessWidget {
  const PageTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final header = PageTableHeaderWidget(
      onAdd: () => showDialog(
        context: context,
        builder: (context) => const CreateOrUpdatePageLayout(),
      ),
      onClearAllFilters: () => debugPrint('onClearAllFilters'),
    );
    // 中间部分是一个 DataTable
    final content = PageLayoutDataTable(
      pageLayouts: [
        PageLayout(
          id: 1,
          title: '首页',
          platform: Platform.app,
          status: PageStatus.draft,
          pageType: PageType.home,
          config: const PageConfig(
            baselineScreenWidth: 375,
          ),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        ),
        PageLayout(
          id: 2,
          title: '首页',
          platform: Platform.web,
          status: PageStatus.published,
          pageType: PageType.home,
          config: const PageConfig(
            baselineScreenWidth: 375,
          ),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        ),
        PageLayout(
          id: 3,
          title: '首页',
          platform: Platform.app,
          status: PageStatus.draft,
          pageType: PageType.category,
          config: const PageConfig(
            baselineScreenWidth: 375,
          ),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        ),
      ],
      onDelete: (layout) => debugPrint('onDelete: $layout'),
      onDraft: (layout) => debugPrint('onDraft: $layout'),
      onEdit: (layout) => debugPrint('onEdit: $layout'),
      onPublish: (layout) => debugPrint('onPublish: $layout'),
      onFilterTitle: (value) => debugPrint('onFilterTitle: $value'),
      onFilterPlatform: (value) => debugPrint('onFilterPlatform: $value'),
      onFilterPageStatus: (value) => debugPrint('onFilterPageStatus: $value'),
      onFilterPageType: (value) => debugPrint('onFilterPageType: $value'),
      onFilterStartTime: (value) => debugPrint('onFilterStartTime: $value'),
      onFilterEndTime: (value) => debugPrint('onFilterEndTime: $value'),
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
