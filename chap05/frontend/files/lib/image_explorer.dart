import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ImageExplorer extends StatelessWidget {
  const ImageExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    // 界面分为三个纵向排列的区域：顶部是一个标题栏，中间是一个缩略图列表，底部是一个按钮栏
    // 其中缩略图列表是一个垂直滚动的每行 3 列的网格，每个列表项是一个缩略图和一个文本标签
    // 标题栏的左侧是一个文本标签，右侧是是一个复选框：用于切换缩略图是否可以选择。如果可以选择，缩略图的右上角会显示一个复选框
    // 按钮栏是一个横向排列的按钮列表，每个按钮都是一个文本标签。包括上传、删除、取消三个按钮。
    // 只有在选择了图片的情况下，删除按钮才变为可用状态。上传按钮始终可用，取消按钮始终可用
    // 如果设置为缩略图不可选择，那么点击任何一张图片，会触发一个事件，将当前图片的路径传递给外部
    final titleWidget = [
      const Text('图片浏览器'),
      const Spacer(),
      Checkbox(
        value: false,
        onChanged: (value) {},
      ),
      const Text('启用多选')
    ].toRow();

    final thumbnailWidget = [
      Image.network(
        'http://localhost:8080/api/v1/app/image/200',
        fit: BoxFit.cover,
      ).expanded(),
      const Text('图片1'),
    ].toColumn();

    final gridWidget = GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return thumbnailWidget;
      },
    );

    final bottomWidget = [
      ElevatedButton(
        onPressed: () {},
        child: const Text('上传'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('删除'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('取消'),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );

    return [
      titleWidget,
      gridWidget.expanded(),
      bottomWidget,
    ].toColumn();
  }
}
