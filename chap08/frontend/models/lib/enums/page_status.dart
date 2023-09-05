/// 页面状态
/// - draft: 草稿
/// - published: 已发布
/// - archived: 已归档，过期后会自动归档
enum PageStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  final String value;

  const PageStatus(this.value);
}
