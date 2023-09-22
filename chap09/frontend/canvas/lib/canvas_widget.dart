import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

class CanvasWidget extends StatelessWidget {
  final int pageLayoutId;
  const CanvasWidget({
    super.key,
    required this.pageLayoutId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(),
        ),
        RepositoryProvider<PageBlockAdminRepository>(
          create: (context) => PageBlockAdminRepository(),
        ),
        RepositoryProvider<PageBlockDataAdminRepository>(
          create: (context) => PageBlockDataAdminRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CanvasBloc(
          pageAdminRepository: context.read<PageAdminRepository>(),
          pageBlockAdminRepository: context.read<PageBlockAdminRepository>(),
          pageBlockDataAdminRepository:
              context.read<PageBlockDataAdminRepository>(),
        )..add(
            CanvasEventLoaded(pageLayoutId),
          ),
        child: BlocBuilder<CanvasBloc, CanvasState>(
          builder: (context, state) {
            if (state.isFailure) {
              return const Center(
                child: Text('Failed to load page layout'),
              );
            }
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.isSuccess) {
              return _buildCanvas(context, state);
            }
            return const Center(
              child: Text('Unknown error'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCanvas(BuildContext context, CanvasState state) {
    final bloc = context.read<CanvasBloc>();
    return [
      const LeftPaneWidget().expanded(),
      CenterPaneWidget(
        blocks: state.blocks,
        baselineScreenWidth: state.pageConfig.baselineScreenWidth,
        onBlockAdded: (value) {
          bloc.add(
            CanvasEventCreateBlock(value),
          );
        },
        onBlockMoved: (from, to) {
          if (from.id == to.id || from.id == null || to.id == null) {
            return;
          }
          bloc.add(
            CanvasEventMoveBlock(from.id!, to.id!),
          );
        },
        onBlockDeleted: (value) async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => const ConfirmDialog(
              title: '删除区块',
              content: '是否确认删除此区块？',
            ),
          );
          if (result == true) {
            bloc.add(
              CanvasEventDeleteBlock(value.id!),
            );
          }
        },
        onBlockEdited: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(
            CanvasEventSelectBlock(value.id!),
          );
        },
      ).constrained(
        width: state.pageConfig.baselineScreenWidth + 80,
      ),
      RightPaneWidget(
        onUpdateBlock: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(
            CanvasEventUpdateBlock(value.id!, value),
          );
        },
        onMoveData: (from, to) {
          if (from.id == to.id || from.id == null || to.id == null) {
            return;
          }
          bloc.add(
            CanvasEventMoveBlockData(from.id!, to.id!),
          );
        },
        onUpdateData: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(
            CanvasEventUpdateBlockData(value.id!, value),
          );
        },
        block: state.selectedBlock,
      ).expanded(),
    ].toRow();
  }
}
