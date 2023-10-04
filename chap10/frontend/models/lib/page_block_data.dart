import 'package:equatable/equatable.dart';

import 'block_data.dart';

class PageBlockData<T extends BlockData> extends Equatable {
  final int? id;
  final int sort;
  final T content;

  const PageBlockData({
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
  List<Object?> get props => [id, sort, content];

  @override
  String toString() {
    return 'PageBlockData{id: $id, sort: $sort, content: $content}';
  }

  PageBlockData<T> copyWith({
    int? id,
    int? sort,
    T? content,
  }) {
    return PageBlockData(
      id: id ?? this.id,
      sort: sort ?? this.sort,
      content: content ?? this.content,
    );
  }
}
