import 'block_data.dart';

class Category implements BlockData {
  final int? id;
  final String? name;
  final String? code;
  final List<Category> children;

  const Category({
    this.id,
    this.name,
    this.code,
    this.children = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
