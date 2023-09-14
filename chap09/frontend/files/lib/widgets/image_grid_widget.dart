import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'thumbnail_widget.dart';

class ImageGridWidget extends StatelessWidget {
  final List<FileVM> images;
  final List<String> selectedKeys;
  final Function(String)? onToggleSelected;
  final Function(FileVM)? onTap;
  final bool editable;
  const ImageGridWidget({
    super.key,
    required this.images,
    this.selectedKeys = const [],
    this.onToggleSelected,
    this.onTap,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final image = images[index];

        final normalWidget = ThumbnailWidget(
          imageSrc: image.url ?? '',
          label: _getPrefix(image.key ?? ''),
        ).inkWell(onTap: () => onTap?.call(image));

        final checkedIcon = Icon(
          selectedKeys.contains(image.key)
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color: Colors.purpleAccent,
        )
            .inkWell(
              onTap: () => onToggleSelected?.call(image.key ?? ''),
            )
            .positioned(
              top: 0,
              right: 0,
            );

        final selectedWidget = [
          normalWidget,
          checkedIcon,
        ].toStack();

        return editable ? selectedWidget : normalWidget;
      },
      itemCount: images.length,
    );
  }

  // 获取字符串在最后一个 _ 之前的部分
  String _getPrefix(String key) {
    final index = key.lastIndexOf('_');
    if (index == -1) {
      return key;
    } else {
      return key.substring(0, index);
    }
  }
}
