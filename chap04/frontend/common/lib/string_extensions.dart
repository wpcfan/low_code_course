import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String get first => this[0];
  String get last => this[length - 1];

  EasyRichText toEasyRichText({
    TextStyle? defaultStyle,
    List<EasyRichTextPattern>? patternList,
  }) {
    return EasyRichText(
      this,
      defaultStyle: defaultStyle,
      patternList: patternList,
    );
  }

  // 价格的富文本展示
  EasyRichText toPriceWithDecimalSize({
    double defaultFontSize = 14,
    double decimalFontSize = 12,
    String decimalSign = '.',
  }) {
    final defaultTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: defaultFontSize,
      color: Colors.red,
    );
    // 根据小数点分割
    final parts = split(decimalSign);
    // 如果没有小数点，直接返回
    if (parts.length != 2) {
      return toEasyRichText(defaultStyle: defaultTextStyle);
    }

    final decimalPart = parts.last;
    final decimalTextStyle =
        defaultTextStyle.copyWith(fontSize: decimalFontSize);

    return EasyRichText(
      this,
      defaultStyle: defaultTextStyle,
      patternList: [
        EasyRichTextPattern(
          targetString: decimalPart,
          style: decimalTextStyle,
        ),
      ],
    );
  }
}
