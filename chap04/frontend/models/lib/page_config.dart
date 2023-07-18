class PageConfig {
  final double? baseScreenWidth;

  const PageConfig({
    this.baseScreenWidth,
  });

  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      baseScreenWidth: json['baseScreenWidth'] as double?,
    );
  }
}
