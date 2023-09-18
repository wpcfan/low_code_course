import 'package:common/common.dart';
import 'package:flutter/material.dart';

class LeftPaneWidget extends StatelessWidget {
  const LeftPaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const oneRowOneImage = ListTile(
      title: Text('一行一图片组件'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const oneRowTwoImage = ListTile(
      title: Text('一行两图片组件'),
      subtitle: Text('此组件一般用类目推荐位'),
    );
    return ListView(
      children: [
        Draggable(
          childWhenDragging: oneRowOneImage.opacity(0.6),
          feedback: Theme(
            data: ThemeData.dark(),
            child: oneRowOneImage
                .constrained(
                  width: 200,
                  height: 80,
                )
                .decorated(
                  color: Colors.deepPurple,
                ),
          ),
          child: oneRowOneImage,
        ),
        const Divider(),
        Draggable(
          childWhenDragging: oneRowTwoImage,
          feedback: oneRowTwoImage
              .constrained(
                width: 200,
                height: 80,
              )
              .decorated(
                color: Colors.deepPurple,
              ),
          child: oneRowTwoImage,
        ),
      ],
    );
  }
}
