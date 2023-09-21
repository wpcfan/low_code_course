import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import 'constants.dart';

class CanvasState extends Equatable {
  final PageLayout? pageLayout;
  final int? selectedBlockId;
  final String? error;
  final bool saving;
  final FetchStatus status;

  get isInitial => status == FetchStatus.initial;
  get isFailure => status == FetchStatus.failure;
  get isSuccess => status == FetchStatus.success;
  get isLoading => status == FetchStatus.loading;
  List<PageBlock> get blocks => pageLayout?.blocks ?? [];
  get pageConfig =>
      pageLayout?.config ??
      const PageConfig(
        baselineScreenWidth: Constants.baselineScreenWidth,
      );
  get pageLayoutId => pageLayout?.id;
  PageBlock? get selectedBlock {
    if (selectedBlockId == null) return null;
    return blocks.firstWhere((block) => block.id == selectedBlockId);
  }

  get selectedBlockType => selectedBlock?.type;
  get selectedBlockConfig =>
      selectedBlock?.config ??
      const BlockConfig(
        blockHeight: Constants.defaultBlockHeight,
        horizontalPadding: Constants.defaultHorizontalPadding,
        verticalPadding: Constants.defaultVerticalPadding,
        horizontalSpacing: Constants.defaultHorizontalSpacing,
        verticalSpacing: Constants.defaultVerticalSpacing,
      );
  List<PageBlockData<BlockData>> get selectedBlockData =>
      selectedBlock?.data ?? [];

  const CanvasState({
    this.pageLayout,
    this.selectedBlockId,
    this.error,
    this.saving = false,
    this.status = FetchStatus.initial,
  });

  @override
  List<Object?> get props => [
        pageLayout,
        selectedBlock,
        error,
      ];

  CanvasState copyWith({
    PageLayout? pageLayout,
    int? selectedBlockId,
    String? error,
    bool? saving,
    FetchStatus? status,
  }) {
    return CanvasState(
      pageLayout: pageLayout ?? this.pageLayout,
      selectedBlockId: selectedBlockId ?? this.selectedBlockId,
      error: error ?? this.error,
      saving: saving ?? this.saving,
      status: status ?? this.status,
    );
  }

  factory CanvasState.initial() {
    return const CanvasState();
  }
}
