enum LinkType {
  url('url'),
  route('route'),
  ;

  final String value;
  const LinkType(this.value);
}

class MyLink {
  final LinkType type;
  final String value;

  const MyLink({
    required this.type,
    required this.value,
  });
}
