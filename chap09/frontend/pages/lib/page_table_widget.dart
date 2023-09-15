import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'popups/popups.dart';
import 'widgets/widgets.dart';

class PageTableWidget extends StatelessWidget {
  final Function(int)? onSelect;
  const PageTableWidget({
    super.key,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PageBloc(PageAdminRepository())..add(PageEventClearAll()),
      child: Builder(builder: (context) {
        return BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            final bloc = context.read<PageBloc>();
            return LayoutBuilder(
              builder: (context, constraints) => [
                _buildHeader(context, bloc),
                _buildContent(context, bloc, state)
                    .constrained(minWidth: constraints.maxWidth)
                    .scrollable()
                    .expanded(),
                _buildFooter(context, bloc, state),
              ].toColumn(mainAxisSize: MainAxisSize.max),
            );
          },
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, PageBloc bloc) {
    return PageTableHeaderWidget(
      onAdd: () => showDialog(
        context: context,
        builder: (context) => CreateOrUpdatePageLayout(
          title: '新增页面布局',
          onCreated: (layout) => bloc.add(PageEventCreate(layout)),
        ),
      ),
      onClearAllFilters: () => bloc.add(PageEventClearAll()),
    );
  }

  Widget _buildFooter(BuildContext context, PageBloc bloc, PageState state) {
    return PageTableFooterWidget(
      totalSize: state.total,
      totalPage: state.totalPage,
      currentPage: state.page + 1,
      onFirstPage: () => bloc.add(PageEventPageChanged(0)),
      onPreviousPage: () => bloc.add(PageEventPageChanged(state.page - 1)),
      onNextPage: () => bloc.add(PageEventPageChanged(state.page + 1)),
      onLastPage: () => bloc.add(PageEventPageChanged(state.totalPage - 1)),
    );
  }

  Widget _buildContent(BuildContext context, PageBloc bloc, PageState state) {
    return PageLayoutDataTable(
      pageLayouts: state.items,
      query: state.query,
      onDelete: (layout) => bloc.add(PageEventDelete(layout.id!)),
      onDraft: (layout) => bloc.add(PageEventDraft(layout.id!)),
      onEdit: (layout) => showDialog(
        context: context,
        builder: (context) => CreateOrUpdatePageLayout(
          title: '编辑页面布局',
          pageLayout: layout,
          onUpdated: (layout) => bloc.add(PageEventUpdate(layout.id!, layout)),
        ),
      ),
      onPublish: (layout, start, end) =>
          bloc.add(PageEventPublish(layout.id!, start, end)),
      onFilterTitle: (value) => bloc.add(PageEventTitleChanged(value)),
      onFilterPlatform: (value) => bloc.add(PageEventPlatformChanged(value)),
      onFilterPageStatus: (value) =>
          bloc.add(PageEventPageStatusChanged(value)),
      onFilterPageType: (value) => bloc.add(PageEventPageTypeChanged(value)),
      onFilterStartTime: (value) =>
          bloc.add(PageEventStartTimeChanged(value?.start, value?.end)),
      onFilterEndTime: (value) =>
          bloc.add(PageEventEndTimeChanged(value?.start, value?.end)),
      onSelect: (id) => onSelect?.call(id),
    );
  }
}
