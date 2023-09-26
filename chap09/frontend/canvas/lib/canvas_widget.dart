import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../popups/popups.dart';
import 'blocs/blocs.dart';
import 'constants.dart';
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
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CanvasBloc(
          productRepository: context.read<ProductRepository>(),
          pageAdminRepository: context.read<PageAdminRepository>(),
          pageBlockAdminRepository: context.read<PageBlockAdminRepository>(),
          pageBlockDataAdminRepository:
              context.read<PageBlockDataAdminRepository>(),
        )..add(CanvasEventLoaded(pageLayoutId)),
        child: BlocConsumer<CanvasBloc, CanvasState>(
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<CanvasBloc>().add(CanvasEventClearError());
            }
          },
          builder: (context, state) {
            final bloc = context.read<CanvasBloc>();
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
              return _buildScaffold(context, state, bloc);
            }
            return const Center(child: Text('Unknown error'));
          },
        ),
      ),
    );
  }

  Widget _buildScaffold(
      BuildContext context, CanvasState state, CanvasBloc bloc) {
    final bool isBannerSelected = state.selectedBlockId != null &&
        state.selectedBlock != null &&
        state.selectedBlock!.type == PageBlockType.banner;
    final addBannerImageBtn = FloatingActionButton(
      onPressed: () => _handleAddBannerImage(state, bloc, context),
      child: const Icon(Icons.add),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(state.pageLayout?.title ?? ''),
      ),
      body: _buildCanvas(context, state, bloc),
      floatingActionButton: isBannerSelected ? addBannerImageBtn : null,
    );
  }

  void _handleAddBannerImage(
    CanvasState state,
    CanvasBloc bloc,
    BuildContext context,
  ) async {
    if (state.selectedBlockData.length >=
        Constants.defaultBannerImageMaxCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('轮播图最多只能添加${Constants.defaultBannerImageMaxCount}张图片'),
        ),
      );
      return;
    }
    final result = await showDialog<ImageData>(
      context: context,
      builder: (context) {
        return const CreateOrUpdateImageDataWidget(
          title: '添加图片',
        );
      },
    );
    if (result != null) {
      bloc.add(
        CanvasEventCreateBlockData(PageBlockData(
          sort: state.selectedBlockData.length + 1,
          content: result,
        )),
      );
    }
  }

  Widget _buildCanvas(
      BuildContext context, CanvasState state, CanvasBloc bloc) {
    return [
      LeftPaneWidget(
        blocksCount: state.blocks.length,
      ).expanded(),
      CenterPaneWidget(
        blocks: state.blocks,
        waterfallItems: state.waterfallItems,
        baselineScreenWidth: state.pageConfig.baselineScreenWidth,
        onBlockAdded: (value) {
          bloc.add(CanvasEventCreateBlock(value));
        },
        onBlockMoved: (from, to) {
          if (from.id == to.id || from.id == null || to.id == null) {
            return;
          }
          bloc.add(CanvasEventMoveBlock(from.id!, to.id!));
        },
        onBlockDeleted: (value) async {
          if (value.id == null) {
            return;
          }
          bloc.add(CanvasEventDeleteBlock(value.id!));
        },
        onBlockEdited: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(CanvasEventSelectBlock(value.id!));
        },
      ).constrained(
        width: state.pageConfig.baselineScreenWidth + 80,
      ),
      RightPaneWidget(
        onUpdateBlock: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(CanvasEventUpdateBlock(value.id!, value));
        },
        onMoveData: (from, to) {
          if (from.id == to.id || from.id == null || to.id == null) {
            return;
          }
          bloc.add(CanvasEventMoveBlockData(from.id!, to.id!));
        },
        onUpdateData: (value) {
          if (value.id == null) {
            return;
          }
          bloc.add(CanvasEventUpdateBlockData(value.id!, value));
        },
        onDeleteData: (value) async {
          if (value.id == null) {
            return;
          }
          bloc.add(CanvasEventDeleteBlockData(value.id!));
        },
        onCreateData: (value) async {
          bloc.add(CanvasEventCreateBlockData(value));
        },
        block: state.selectedBlock,
      ).expanded(),
    ].toRow();
  }
}
