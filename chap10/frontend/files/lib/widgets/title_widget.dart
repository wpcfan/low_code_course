import 'package:common/common.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String labelForCheckbox;
  final bool isChecked;
  final Function(bool?)? onCheckboxChanged;

  const TitleWidget({
    super.key,
    this.title = '图片浏览器',
    this.labelForCheckbox = '启用多选',
    this.isChecked = false,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Text(title),
      const Spacer(),
      Checkbox(
        value: isChecked,
        onChanged: onCheckboxChanged,
      ),
      Text(labelForCheckbox)
    ].toRow().padding(all: 16.0);
  }
}
