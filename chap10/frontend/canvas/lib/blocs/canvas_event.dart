import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class CanvasEvent extends Equatable {
  const CanvasEvent();

  @override
  List<Object> get props => [];
}

class CanvasEventLoaded extends CanvasEvent {
  final int pageLayoutId;

  const CanvasEventLoaded(this.pageLayoutId);

  @override
  List<Object> get props => [pageLayoutId];
}

class CanvasEventCreateBlock extends CanvasEvent {
  final PageBlock block;

  const CanvasEventCreateBlock(this.block);

  @override
  List<Object> get props => [block];
}

class CanvasEventDeleteBlock extends CanvasEvent {
  final int blockId;

  const CanvasEventDeleteBlock(this.blockId);

  @override
  List<Object> get props => [blockId];
}

class CanvasEventUpdateBlock extends CanvasEvent {
  final int blockId;
  final PageBlock block;

  const CanvasEventUpdateBlock(this.blockId, this.block);

  @override
  List<Object> get props => [blockId, block];
}

class CanvasEventMoveBlock extends CanvasEvent {
  final int fromId;
  final int toId;

  const CanvasEventMoveBlock(this.fromId, this.toId);

  @override
  List<Object> get props => [fromId, toId];
}

class CanvasEventSelectBlock extends CanvasEvent {
  final int blockId;

  const CanvasEventSelectBlock(this.blockId);

  @override
  List<Object> get props => [blockId];
}

class CanvasEventCreateBlockData extends CanvasEvent {
  final PageBlockData blockData;

  const CanvasEventCreateBlockData(this.blockData);

  @override
  List<Object> get props => [blockData];
}

class CanvasEventDeleteBlockData extends CanvasEvent {
  final int blockDataId;

  const CanvasEventDeleteBlockData(this.blockDataId);

  @override
  List<Object> get props => [blockDataId];
}

class CanvasEventUpdateBlockData extends CanvasEvent {
  final int blockDataId;
  final PageBlockData blockData;

  const CanvasEventUpdateBlockData(
    this.blockDataId,
    this.blockData,
  );

  @override
  List<Object> get props => [blockDataId, blockData];
}

class CanvasEventMoveBlockData extends CanvasEvent {
  final int fromId;
  final int toId;

  const CanvasEventMoveBlockData(this.fromId, this.toId);

  @override
  List<Object> get props => [fromId, toId];
}

class CanvasEventClearError extends CanvasEvent {}

class CanvasEventError extends CanvasEvent {
  final String message;

  const CanvasEventError(this.message);

  @override
  List<Object> get props => [message];
}
