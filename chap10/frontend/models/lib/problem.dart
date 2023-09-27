class Problem {
  final String? title;
  final String? detail;
  final int? status;
  final String? type;
  final String? instance;
  final String? ua;
  final int? code;
  final String? locale;

  Problem({
    this.title,
    this.detail,
    this.status,
    this.type,
    this.instance,
    this.ua,
    this.code,
    this.locale,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      title: json['title'],
      detail: json['detail'],
      status: json['status'],
      type: json['type'],
      instance: json['instance'],
      ua: json['ua'],
      code: json['code'],
      locale: json['locale'],
    );
  }

  @override
  String toString() {
    return 'Problem{title: $title, detail: $detail, status: $status, type: $type, instance: $instance, ua: $ua, code: $code, locale: $locale}';
  }
}
