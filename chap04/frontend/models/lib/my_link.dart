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

  @override
  List<Object?> get props => [type, value];

  factory MyLink.fromJson(Map<String, dynamic> json) {
    return MyLink(
      type: LinkType.values.firstWhere((e) => e.value == json['type']),
      value: json['value'] as String,
    );
  }
}
