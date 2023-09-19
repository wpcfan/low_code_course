import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class LeftPaneWidget extends StatelessWidget {
  const LeftPaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultBlockConfig = BlockConfig(
      blockHeight: 100,
      horizontalSpacing: 12,
      verticalSpacing: 12,
      horizontalPadding: 12,
      verticalPadding: 12,
    );
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
          data: PageBlock(
            sort: 0,
            title: '一行一图片组件',
            type: PageBlockType.imageRow,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: [
              PageBlockData<ImageData>(
                sort: 1,
                content: const ImageData(
                  image: 'http://localhost:8080/api/v1/app/image/400/100',
                  link: MyLink(
                    type: LinkType.url,
                    value: 'https://www.baidu.com',
                  ),
                ),
              ),
            ],
          ),
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
          data: PageBlock(
            sort: 0,
            title: '一行两图片组件',
            type: PageBlockType.imageRow,
            config: defaultBlockConfig.copyWith(blockHeight: 120),
            data: [
              PageBlockData<ImageData>(
                sort: 1,
                content: const ImageData(
                  image: 'http://localhost:8080/api/v1/app/image/190/120',
                  link: MyLink(
                    type: LinkType.url,
                    value: 'https://www.baidu.com',
                  ),
                ),
              ),
              PageBlockData<ImageData>(
                sort: 2,
                content: const ImageData(
                  image: 'http://localhost:8080/api/v1/app/image/190/120',
                  link: MyLink(
                    type: LinkType.url,
                    value: 'https://www.baidu.com',
                  ),
                ),
              ),
            ],
          ),
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
