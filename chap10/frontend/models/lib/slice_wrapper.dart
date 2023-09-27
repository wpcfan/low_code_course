class SliceWrapper<T> {
  final int page;
  final int size;
  final bool hasNext;
  final List<T> items;

  const SliceWrapper({
    required this.page,
    required this.size,
    required this.hasNext,
    required this.items,
  });

  factory SliceWrapper.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return SliceWrapper(
      page: json['page'],
      size: json['size'],
      hasNext: json['hasNext'],
      items: (json['items'] as List).map((e) => fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'SliceWrapper{page: $page, size: $size, hasNext: $hasNext, items: $items}';
  }
}
