class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? blockHeight;
  final double? horizontalSpacing;
  final double? verticalSpacing;
  final double? blockWidth;

  const BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.blockHeight,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.blockWidth,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] != null
          ? double.tryParse(json['horizontalPadding'].toString())
          : null,
      verticalPadding: json['verticalPadding'] != null
          ? double.tryParse(json['verticalPadding'].toString())
          : null,
      blockHeight: json['blockHeight'] != null
          ? double.tryParse(json['blockHeight'].toString())
          : null,
      horizontalSpacing: json['horizontalSpacing'] != null
          ? double.tryParse(json['horizontalSpacing'].toString())
          : null,
      verticalSpacing: json['verticalSpacing'] != null
          ? double.tryParse(json['verticalSpacing'].toString())
          : null,
      blockWidth: json['blockWidth'] != null
          ? double.tryParse(json['blockWidth'].toString())
          : null,
    );
  }

  BlockConfig withRatio(double ratio, double baselineScreenWidth) {
    return BlockConfig(
      horizontalPadding: (horizontalPadding ?? 0) * ratio,
      verticalPadding: (verticalPadding ?? 0) * ratio,
      blockHeight: (blockHeight ?? 0) * ratio,
      horizontalSpacing: (horizontalSpacing ?? 0) * ratio,
      verticalSpacing: (verticalSpacing ?? 0) * ratio,
      blockWidth: blockWidth == null
          ? baselineScreenWidth * ratio
          : (blockWidth ?? 0) * ratio,
    );
  }
}
