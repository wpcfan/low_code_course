/// 页面区块类型
/// - banner: 轮播图
/// - imageRow: 图片行
/// - productRow: 商品行
/// - waterfall: 瀑布流
enum PageBlockType {
  banner('Banner'),
  imageRow('ImageRow'),
  productRow('ProductRow'),
  waterfall('Waterfall'),
  unknown('unknown');

  final String value;
  const PageBlockType(this.value);
}
