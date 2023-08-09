class FileVM {
  final String? key;
  final String? url;

  FileVM({this.key, this.url});

  factory FileVM.fromJson(Map<String, dynamic> json) {
    return FileVM(
      key: json['key'],
      url: json['url'],
    );
  }
}
