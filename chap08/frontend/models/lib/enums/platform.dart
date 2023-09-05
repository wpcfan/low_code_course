/// 平台类型
/// - app: App 包括 iOS 和 Android
/// - web: Web 包括移动网页，暂时不包括 PC 端网页
enum Platform {
  app('App'),
  web('Web');

  final String value;

  const Platform(this.value);
}
