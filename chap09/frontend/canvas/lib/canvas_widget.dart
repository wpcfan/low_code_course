import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class CanvasWidget extends StatelessWidget {
  final int pageLayoutId;
  const CanvasWidget({
    super.key,
    required this.pageLayoutId,
  });

  @override
  Widget build(BuildContext context) {
    return [
      const CenterPaneWidget().expanded(),
      const RightPaneWidget().expanded(),
    ].toRow();
  }
}
