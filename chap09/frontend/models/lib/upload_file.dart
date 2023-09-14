import 'dart:typed_data';

class UploadFile {
  final String name;
  final Uint8List bytes;

  UploadFile({
    required this.name,
    required this.bytes,
  });

  factory UploadFile.fromJson(Map<String, dynamic> map) {
    return UploadFile(
      name: map['name'],
      bytes: map['file'],
    );
  }
}
