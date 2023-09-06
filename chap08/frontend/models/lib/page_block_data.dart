import 'block_data.dart';

class PageBlockData<T extends BlockData> {
  final int? id;
  final int sort;
  final T content;

  PageBlockData({
    this.id,
    required this.sort,
    required this.content,
  });

  factory PageBlockData.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageBlockData(
      id: json['id'],
      sort: json['sort'],
      content: fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sort': sort,
      'content': content.toJson(),
    };
  }

  @override
  String toString() {
    return 'PageBlockData{id: $id, sort: $sort, content: $content}';
  }
}
