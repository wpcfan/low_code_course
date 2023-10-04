import 'package:equatable/equatable.dart';

enum LinkType {
  url('url'),
  route('route'),
  ;

  final String value;
  const LinkType(this.value);
}

class MyLink extends Equatable {
  final LinkType type;
  final String value;

  const MyLink({
    required this.type,
    required this.value,
  });

  factory MyLink.fromJson(Map<String, dynamic> json) {
    return MyLink(
      type: LinkType.values.firstWhere((e) => e.value == json['type']),
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [type, value];

  @override
  String toString() {
    return 'MyLink{type: $type, value: $value}';
  }

  MyLink copyWith({
    LinkType? type,
    String? value,
  }) {
    return MyLink(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
