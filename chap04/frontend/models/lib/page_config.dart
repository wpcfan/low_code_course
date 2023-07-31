import 'package:equatable/equatable.dart';

class PageConfig extends Equatable {
  final double? baseScreenWidth;

  const PageConfig({
    this.baseScreenWidth,
  });

  @override
  List<Object?> get props => [
        baseScreenWidth,
      ];

  @override
  String toString() {
    return 'PageConfig{baseScreenWidth: $baseScreenWidth}';
  }

  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      baseScreenWidth: json['baseScreenWidth'] != null
          ? double.tryParse(json['baseScreenWidth'].toString())
          : null,
    );
  }
}
