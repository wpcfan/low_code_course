class PageConfig {
  final double? baselineScreenWidth;

  const PageConfig({
    this.baselineScreenWidth,
  });

  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      baselineScreenWidth: json['baselineScreenWidth'] != null
          ? double.tryParse(json['baselineScreenWidth'].toString())
          : null,
    );
  }
}
