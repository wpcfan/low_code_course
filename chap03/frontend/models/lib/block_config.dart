class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? blockHeight;
  final double? horozontalSpacing;

  const BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.blockHeight,
    this.horozontalSpacing,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      blockHeight: json['blockHeight'] as double?,
      horozontalSpacing: json['horozontalSpacing'] as double?,
    );
  }
}
