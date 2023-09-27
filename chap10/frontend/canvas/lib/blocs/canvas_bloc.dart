import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final PageAdminRepository pageAdminRepository;
  final PageBlockAdminRepository pageBlockAdminRepository;
  final PageBlockDataAdminRepository pageBlockDataAdminRepository;
  final ProductRepository productRepository;
  CanvasBloc({
    required this.pageAdminRepository,
    required this.pageBlockAdminRepository,
    required this.pageBlockDataAdminRepository,
    required this.productRepository,
  }) : super(CanvasState.initial()) {
    on<CanvasEventLoaded>(_onCanvasEventLoad);
    on<CanvasEventSelectBlock>(_onCanvasEventSelectBlock);
    on<CanvasEventCreateBlock>(_onCanvasEventCreateBlock);
    on<CanvasEventUpdateBlock>(_onCanvasEventUpdateBlock);
    on<CanvasEventDeleteBlock>(_onCanvasEventDeleteBlock);
    on<CanvasEventMoveBlock>(_onCanvasEventMoveBlock);
    on<CanvasEventUpdateBlockData>(_onCanvasEventUpdateBlockData);
    on<CanvasEventCreateBlockData>(_onCanvasEventCreateBlockData);
    on<CanvasEventDeleteBlockData>(_onCanvasEventDeleteBlockData);
    on<CanvasEventMoveBlockData>(_onCanvasEventMoveBlockData);
    on<CanvasEventClearError>(_onCanvasEventClearError);
    on<CanvasEventError>(_onCanvasEventError);
  }

  Future<void> _onCanvasEventError(
    CanvasEventError event,
    Emitter<CanvasState> emit,
  ) async {
    emit(state.copyWith(
      error: event.message,
    ));
  }

  Future<void> _onCanvasEventClearError(
    CanvasEventClearError event,
    Emitter<CanvasState> emit,
  ) async {
    emit(state.copyWith(
      error: '',
    ));
  }

  Future<void> _onCanvasEventLoad(
    CanvasEventLoaded event,
    Emitter<CanvasState> emit,
  ) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final pageLayout = await pageAdminRepository.get(
        event.pageLayoutId,
      );
      if (pageLayout.blocks
          .any((block) => block.type == PageBlockType.waterfall)) {
        final waterfallBlock = pageLayout.blocks
            .firstWhere((block) => block.type == PageBlockType.waterfall);
        final waterfallData =
            waterfallBlock.data.map((e) => e.content as Category).toList();
        if (waterfallData.isNotEmpty) {
          final category = waterfallData.first;

          final waterfallItems = await loadProductsByCategory(
            category: category,
            pageLayout: pageLayout,
          );
          emit(state.copyWith(
            pageLayout: pageLayout,
            waterfallItems: waterfallItems,
            status: FetchStatus.success,
          ));
          return;
        }
      }
      emit(state.copyWith(
        pageLayout: pageLayout,
        status: FetchStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: FetchStatus.failure,
      ));
    }
  }

  Future<List<Product>> loadProductsByCategory({
    required Category category,
    required PageLayout pageLayout,
  }) async {
    try {
      final slice = await productRepository.getProductsByCategoryId(
        categoryId: category.id!,
        pageNum: 0,
        pageSize: 4,
      );
      return slice.items;
    } catch (e) {
      return [];
    }
  }

  Future<void> _onCanvasEventSelectBlock(
    CanvasEventSelectBlock event,
    Emitter<CanvasState> emit,
  ) async {
    emit(state.copyWith(
      selectedBlockId: event.blockId,
    ));
  }

  Future<void> _onCanvasEventCreateBlock(
    CanvasEventCreateBlock event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null) {
      emit(state.copyWith(
        error: '页面布局不存在',
      ));
      return;
    }
    if (state.hasWaterfallBlock &&
        event.block.type == PageBlockType.waterfall) {
      emit(state.copyWith(
        error: '已存在瀑布流模块',
      ));
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      final block = await pageBlockAdminRepository.create(
        state.pageLayoutId!,
        event.block,
      );
      List<PageBlock> newBlocks = [];
      if (state.hasWaterfallBlock) {
        newBlocks = [
          ...state.blocks.sublist(0, state.blocks.length - 1),
          block,
          state.blocks.last.copyWith(sort: state.blocks.length + 1),
        ];
      } else {
        newBlocks = [
          ...state.blocks,
          block,
        ];
      }
      emit(state.copyWith(
        pageLayout: state.pageLayout?.copyWith(
          blocks: newBlocks..sort((a, b) => a.sort.compareTo(b.sort)),
        ),
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventUpdateBlock(
    CanvasEventUpdateBlock event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      final block = await pageBlockAdminRepository.update(
        state.pageLayoutId!,
        event.blockId,
        event.block,
      );
      emit(state.copyWith(
        pageLayout: state.pageLayout?.copyWith(
          blocks: [
            for (final b in state.blocks)
              if (b.id == event.blockId) block else b,
          ],
        ),
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventDeleteBlock(
    CanvasEventDeleteBlock event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      await pageBlockAdminRepository.delete(
        state.pageLayoutId!,
        event.blockId,
      );
      final blockTypeDeleted = state.blocks
          .firstWhere(
            (b) => b.id == event.blockId,
          )
          .type;
      final sort = state.blocks
          .firstWhere(
            (b) => b.id == event.blockId,
          )
          .sort;
      final newBlocks = [
        for (final b in state.blocks)
          if (b.id != event.blockId) b,
      ];

      // 更新所有大于 sort 的 block 顺序
      final newPageLayout = state.pageLayout?.copyWith(
        blocks: [
          for (final b in newBlocks)
            if (b.sort > sort) b.copyWith(sort: b.sort - 1) else b,
        ]..sort((a, b) => a.sort.compareTo(b.sort)),
      );

      if (state.selectedBlockId == event.blockId) {
        emit(CanvasState(
          pageLayout: newPageLayout,
          waterfallItems: blockTypeDeleted == PageBlockType.waterfall
              ? []
              : state.waterfallItems,
          selectedBlockId: null,
          saving: false,
          status: FetchStatus.success,
        ));
      } else {
        emit(state.copyWith(
          pageLayout: newPageLayout,
          waterfallItems: blockTypeDeleted == PageBlockType.waterfall
              ? []
              : state.waterfallItems,
          saving: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventMoveBlock(
    CanvasEventMoveBlock event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      await pageBlockAdminRepository.move(
        state.pageLayoutId!,
        event.fromId,
        event.toId,
      );
      // 首先需要根据 sort 排序 state.blocks
      // 如果 from 的 sort 大于 to 的 sort，需要更新列表中所有 sort 大于 to 的 sort
      // 如果 from 的 sort 小于 to 的 sort，需要更新列表中所有 sort 小于 to 的 sort
      // 最后更新 from 的 sort 为 to 的 sort

      final sortedBlocks = state.blocks
        ..sort((a, b) => a.sort.compareTo(b.sort));
      final fromIndex = sortedBlocks.indexWhere(
        (block) => block.id == event.fromId,
      );
      final toIndex = sortedBlocks.indexWhere(
        (block) => block.id == event.toId,
      );
      final fromBlock = sortedBlocks[fromIndex];
      final toBlock = sortedBlocks[toIndex];
      final fromSort = fromBlock.sort;
      final toSort = toBlock.sort;
      final List<PageBlock> newBlocks = [
        for (final block in sortedBlocks)
          if (block.id == event.fromId)
            block.copyWith(sort: toSort)
          else if (fromSort > toSort &&
              block.sort >= toSort &&
              block.sort < fromSort)
            block.copyWith(sort: block.sort + 1)
          else if (fromSort < toSort &&
              block.sort <= toSort &&
              block.sort > fromSort)
            block.copyWith(sort: block.sort - 1)
          else
            block,
      ];
      emit(state.copyWith(
        pageLayout: state.pageLayout?.copyWith(
          blocks: newBlocks..sort((a, b) => a.sort.compareTo(b.sort)),
        ),
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventUpdateBlockData(
    CanvasEventUpdateBlockData event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null || state.selectedBlockId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      final blockData = await pageBlockDataAdminRepository.update(
        state.pageLayoutId!,
        state.selectedBlockId!,
        event.blockDataId,
        event.blockData,
      );
      final newBlocks = [
        for (final block in state.blocks)
          if (block.id == state.selectedBlockId)
            block.copyWith(
              data: [
                for (final d in state.selectedBlockData)
                  if (d.id == event.blockDataId) blockData else d,
              ],
            )
          else
            block,
      ];
      final newPageLayout = state.pageLayout?.copyWith(
        blocks: newBlocks,
      );
      if (blockData.content is Category) {
        final category = blockData.content as Category;
        final waterfallItems = await loadProductsByCategory(
          category: category,
          pageLayout: state.pageLayout!,
        );
        emit(state.copyWith(
          pageLayout: newPageLayout,
          waterfallItems: waterfallItems,
          saving: false,
        ));
        return;
      }
      emit(state.copyWith(
        pageLayout: newPageLayout,
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventCreateBlockData(
    CanvasEventCreateBlockData event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null || state.selectedBlockId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      final blockData = await pageBlockDataAdminRepository.create(
        state.pageLayoutId!,
        state.selectedBlockId!,
        event.blockData,
      );
      final newPageLayout = state.pageLayout?.copyWith(
        blocks: [
          for (final block in state.blocks)
            if (block.id == state.selectedBlockId)
              block.copyWith(
                data: [...state.selectedBlockData, blockData],
              )
            else
              block,
        ],
      );
      if (blockData.content is Category) {
        final category = blockData.content as Category;
        final waterfallItems = await loadProductsByCategory(
          category: category,
          pageLayout: state.pageLayout!,
        );
        emit(state.copyWith(
          pageLayout: newPageLayout,
          waterfallItems: waterfallItems,
          saving: false,
        ));
        return;
      }
      emit(state.copyWith(
        pageLayout: newPageLayout,
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventDeleteBlockData(
    CanvasEventDeleteBlockData event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null || state.selectedBlockId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      await pageBlockDataAdminRepository.delete(
        state.pageLayoutId!,
        state.selectedBlockId!,
        event.blockDataId,
      );
      final sort = state.selectedBlockData
          .firstWhere(
            (d) => d.id == event.blockDataId,
          )
          .sort;
      final newBlockData = [
        for (final d in state.selectedBlockData)
          if (d.id != event.blockDataId) d,
      ];
      // 更新所有大于 sort 的 data 顺序
      final newBlocks = [
        for (final block in state.blocks)
          if (block.id == state.selectedBlockId)
            block.copyWith(
              data: [
                for (final b in newBlockData)
                  if (b.sort > sort) b.copyWith(sort: b.sort - 1) else b,
              ]..sort((a, b) => a.sort.compareTo(b.sort)),
            )
          else
            block,
      ];
      emit(state.copyWith(
        pageLayout: state.pageLayout?.copyWith(
          blocks: newBlocks,
        ),
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _onCanvasEventMoveBlockData(
    CanvasEventMoveBlockData event,
    Emitter<CanvasState> emit,
  ) async {
    if (state.pageLayoutId == null || state.selectedBlockId == null) {
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      await pageBlockDataAdminRepository.move(
        state.pageLayoutId!,
        state.selectedBlockId!,
        event.fromId,
        event.toId,
      );
      // 首先需要根据 sort 排序 state.selectedBlockData
      // 如果 from 的 sort 大于 to 的 sort，需要更新列表中所有 sort 大于 to 的 sort
      // 如果 from 的 sort 小于 to 的 sort，需要更新列表中所有 sort 小于 to 的 sort
      // 最后更新 from 的 sort 为 to 的 sort

      final sortedBlockData = state.selectedBlockData
        ..sort((a, b) => a.sort.compareTo(b.sort));
      final fromIndex = sortedBlockData.indexWhere(
        (blockData) => blockData.id == event.fromId,
      );
      final toIndex = sortedBlockData.indexWhere(
        (blockData) => blockData.id == event.toId,
      );
      final fromBlockData = sortedBlockData[fromIndex];
      final toBlockData = sortedBlockData[toIndex];
      final fromSort = fromBlockData.sort;
      final toSort = toBlockData.sort;
      final List<PageBlockData> newBlockData = [
        for (final blockData in sortedBlockData)
          if (blockData.id == event.fromId)
            blockData.copyWith(sort: toSort)
          else if (fromSort > toSort &&
              blockData.sort >= toSort &&
              blockData.sort < fromSort)
            blockData.copyWith(sort: blockData.sort + 1)
          else if (fromSort < toSort &&
              blockData.sort <= toSort &&
              blockData.sort > fromSort)
            blockData.copyWith(sort: blockData.sort - 1)
          else
            blockData,
      ]..sort((a, b) => a.sort.compareTo(b.sort));

      emit(state.copyWith(
        pageLayout: state.pageLayout?.copyWith(
          blocks: [
            for (final block in state.blocks)
              if (block.id == state.selectedBlockId)
                block.copyWith(data: newBlockData)
              else
                block,
          ],
        ),
        saving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }
}
