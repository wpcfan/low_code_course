import 'package:equatable/equatable.dart';

class PageConfig extends Equatable {
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

  Map<String, dynamic> toJson() {
    return {
      'baselineScreenWidth': baselineScreenWidth,
    };
  }

  @override
  List<Object?> get props => [
        baselineScreenWidth,
      ];

  @override
  String toString() {
    return 'PageConfig{baselineScreenWidth: $baselineScreenWidth}';
  }

  PageConfig copyWith({
    double? baselineScreenWidth,
  }) {
    return PageConfig(
      baselineScreenWidth: baselineScreenWidth ?? this.baselineScreenWidth,
    );
  }

  factory PageConfig.empty() {
    return const PageConfig();
  }
}
