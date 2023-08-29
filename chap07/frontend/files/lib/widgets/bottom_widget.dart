import 'package:common/common.dart';
import 'package:flutter/material.dart';

class BottomWidget extends StatelessWidget {
  final Function()? onUpload;
  final Function()? onDelete;
  final Function()? onCancel;
  final bool deleteEnabled;
  final bool cancelDisplayed;
  const BottomWidget({
    super.key,
    this.onUpload,
    this.onDelete,
    this.onCancel,
    this.deleteEnabled = false,
    this.cancelDisplayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: onUpload,
        child: const Text('上传'),
      ),
      deleteEnabled
          ? ElevatedButton(
              onPressed: onDelete,
              child: const Text('删除'),
            )
          : const TextButton(
              onPressed: null,
              child: Text('删除'),
            ),
      const Spacer(),
      if (cancelDisplayed)
        ElevatedButton(
          onPressed: onCancel,
          child: const Text('取消'),
        ),
    ].toRow().padding(all: 16.0);
  }
}
