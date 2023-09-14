import 'package:equatable/equatable.dart';

class FileVM extends Equatable {
  final String? key;
  final String? url;

  const FileVM({this.key, this.url});

  @override
  List<Object?> get props => [key, url];

  factory FileVM.fromJson(Map<String, dynamic> json) {
    return FileVM(
      key: json['key'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'FileVM{key: $key, url: $url}';
  }
}
