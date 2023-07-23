class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? blockHeight;
  final double? horozontalSpacing;
  final double? blockWidth;

  const BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.blockHeight,
    this.horozontalSpacing,
    this.blockWidth,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      blockHeight: json['blockHeight'] as double?,
      horozontalSpacing: json['horozontalSpacing'] as double?,
      blockWidth: json['blockWidth'] as double?,
    );
  }

  BlockConfig withRatio(double ratio) {
    return BlockConfig(
      horizontalPadding: (horizontalPadding ?? 0) * ratio,
      verticalPadding: (verticalPadding ?? 0) * ratio,
      blockHeight: (blockHeight ?? 0) * ratio,
      horozontalSpacing: (horozontalSpacing ?? 0) * ratio,
      blockWidth: (blockWidth ?? 0) * ratio,
    );
  }
}
