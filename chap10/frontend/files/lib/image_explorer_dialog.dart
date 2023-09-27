import 'package:files/image_explorer.dart';
import 'package:flutter/material.dart';

class ImageExplorerDialog extends StatelessWidget {
  const ImageExplorerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 800,
        height: 600,
        child: ImageExplorer(
          onTap: (file) => Navigator.of(context).pop(file.url),
          onCancel: () => Navigator.of(context).pop(),
          cancelDisplayed: true,
        ),
      ),
    );
  }
}
