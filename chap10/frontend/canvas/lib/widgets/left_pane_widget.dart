import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../constants.dart';

class LeftPaneWidget extends StatelessWidget {
  final int blocksCount;
  const LeftPaneWidget({
    super.key,
    required this.blocksCount,
  });

  @override
  Widget build(BuildContext context) {
    const defaultBlockConfig = BlockConfig(
      blockHeight: Constants.defaultBlockHeight,
      horizontalSpacing: Constants.defaultHorizontalSpacing,
      verticalSpacing: Constants.defaultVerticalSpacing,
      horizontalPadding: Constants.defaultHorizontalPadding,
      verticalPadding: Constants.defaultVerticalPadding,
    );
    const oneRowOneImage = ListTile(
      title: Text('一行一图片组件'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const oneRowTwoImage = ListTile(
      title: Text('一行两图片组件'),
      subtitle: Text('此组件一般用类目推荐位'),
    );
    const oneRowThreeImage = ListTile(
      title: Text('一行三图片组件'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const oneRowMoreImage = ListTile(
      title: Text('一行多图片组件'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const banner = ListTile(
      title: Text('轮播图区块'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const oneRowOneProduct = ListTile(
      title: Text('一行一商品区块'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const oneRowTwoProduct = ListTile(
      title: Text('一行两商品区块'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    const waterfall = ListTile(
      title: Text('瀑布流区块'),
      subtitle: Text('此组件一般用于特别活动推荐位'),
    );
    return ListView(
      children: [
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowOneImage,
          type: PageBlockType.imageRow,
          count: 1,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowTwoImage,
          type: PageBlockType.imageRow,
          count: 2,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowThreeImage,
          type: PageBlockType.imageRow,
          count: 3,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowMoreImage,
          type: PageBlockType.imageRow,
          count: 4,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: banner,
          type: PageBlockType.banner,
          count: Constants.defaultBannerImageCount,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowOneProduct,
          type: PageBlockType.productRow,
          count: 1,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: oneRowTwoProduct,
          type: PageBlockType.productRow,
          count: 2,
        ),
        const Divider(),
        _buildDraggableItem(
          config: defaultBlockConfig,
          child: waterfall,
          type: PageBlockType.waterfall,
          count: 1,
        ),
      ],
    );
  }

  Widget _buildDraggableItem({
    required BlockConfig config,
    required Widget child,
    required PageBlockType type,
    int? count,
  }) {
    return Draggable(
      data: _buildPageBlock(
        type: type,
        config: config,
        count: count,
      ),
      childWhenDragging: child.opacity(0.6),
      feedback: Theme(
        data: ThemeData.dark(),
        child: child
            .constrained(
              width: 200,
              height: 80,
            )
            .decorated(
              color: Colors.deepPurple,
            ),
      ),
      child: child,
    );
  }

  String _buildTitle({required PageBlockType type, int? count}) {
    switch (type) {
      case PageBlockType.imageRow:
        switch (count) {
          case 1:
            return '一行一图片区块';
          case 2:
            return '一行两图片区块';
          case 3:
            return '一行三图片区块';
          default:
            return '一行多张可滚动区块';
        }
      case PageBlockType.banner:
        return '轮播图区块';
      case PageBlockType.productRow:
        switch (count) {
          case 1:
            return '一行一商品区块';
          case 2:
          default:
            return '一行两商品区块';
        }
      case PageBlockType.waterfall:
        return '瀑布流区块';
      default:
        return '未知组件';
    }
  }

  PageBlock _buildPageBlock({
    required PageBlockType type,
    required BlockConfig config,
    int? count,
  }) {
    final title = _buildTitle(
      type: type,
      count: count,
    );
    final defaultConfig = _buildBlockConfig(
      config: config,
      type: type,
      count: count,
    );
    switch (type) {
      case PageBlockType.imageRow:
      case PageBlockType.banner:
        return PageBlock(
          sort: blocksCount + 1,
          title: title,
          type: type,
          config: defaultConfig,
          data: _buildImageBlockDataList(
            count: count ?? 1,
            width: _buildImageWidth(count, type),
            height: _buildImageHeight(count, type),
          ),
        );
      case PageBlockType.productRow:
        return PageBlock(
          sort: blocksCount + 1,
          title: title,
          type: type,
          config: defaultConfig,
          data: _buildProductBlockDataList(
            count: count ?? 1,
            width: _buildImageWidth(count, type),
            height: _buildImageHeight(count, type),
          ),
        );
      case PageBlockType.waterfall:
        return PageBlock(
          sort: blocksCount + 1,
          title: title,
          type: type,
          config: defaultConfig,
          data: [],
        );
      default:
        return PageBlock(
          sort: 1,
          title: title,
          type: type,
          config: defaultConfig,
          data: [],
        );
    }
  }

  BlockConfig _buildBlockConfig(
      {required BlockConfig config, required PageBlockType type, int? count}) {
    switch (type) {
      case PageBlockType.imageRow:
        switch (count) {
          case 1:
            return config.copyWith(
                blockHeight: Constants.defaultOneRowOneBlockHeight);
          case 2:
            return config.copyWith(
                blockHeight: Constants.defaultOneRowTwoBlockHeight);
          case 3:
          default:
            return config.copyWith(
                blockHeight: Constants.defaultOneRowThreeBlockHeight);
        }
      case PageBlockType.banner:
        return config.copyWith(blockHeight: Constants.defaultBannerBlockHeight);
      case PageBlockType.productRow:
        switch (count) {
          case 1:
            return config.copyWith(
                blockHeight: Constants.defaultOneRowOneProductBlockHeight);
          case 2:
            return config.copyWith(
                blockHeight: Constants.defaultOneRowTwoProductBlockHeight);
          default:
            return config;
        }
      case PageBlockType.waterfall:
      default:
        return config;
    }
  }

  int _buildImageWidth(int? count, PageBlockType type) {
    switch (type) {
      case PageBlockType.imageRow:
        switch (count) {
          case 1:
            return Constants.defaultOneRowOneImageWidth;
          case 2:
            return Constants.defaultOneRowTwoImageWidth;
          case 3:
          default:
            return Constants.defaultOneRowThreeImageWidth;
        }
      case PageBlockType.banner:
        return Constants.defaultBannerImageWidth;
      case PageBlockType.productRow:
        switch (count) {
          case 1:
            return Constants.defaultOneRowOneProductImageWidth;
          case 2:
          default:
            return Constants.defaultOneRowTwoProductImageWidth;
        }
      default:
        return Constants.defaultOneRowOneImageWidth;
    }
  }

  int _buildImageHeight(int? count, PageBlockType type) {
    switch (type) {
      case PageBlockType.imageRow:
        switch (count) {
          case 1:
            return Constants.defaultOneRowOneImageHeight;
          case 2:
            return Constants.defaultOneRowTwoImageHeight;
          case 3:
          default:
            return Constants.defaultOneRowThreeImageHeight;
        }
      case PageBlockType.banner:
        return Constants.defaultBannerImageHeight;
      case PageBlockType.productRow:
        switch (count) {
          case 1:
            return Constants.defaultOneRowOneProductImageHeight;
          case 2:
          default:
            return Constants.defaultOneRowTwoProductImageHeight;
        }
      default:
        return Constants.defaultOneRowOneImageHeight;
    }
  }

  List<PageBlockData> _buildProductBlockDataList({
    required int count,
    required int width,
    required int height,
  }) {
    final List<PageBlockData> list = [];
    for (var i = 0; i < count; i++) {
      list.add(_buildProductBlockData(
        sort: i + 1,
        width: width,
        height: height,
      ));
    }
    return list;
  }

  List<PageBlockData> _buildImageBlockDataList({
    required int count,
    required int width,
    required int height,
  }) {
    final List<PageBlockData> list = [];
    for (var i = 0; i < count; i++) {
      list.add(_buildImageBlockData(
        sort: i + 1,
        width: width,
        height: height,
      ));
    }
    return list;
  }

  PageBlockData<Product> _buildProductBlockData({
    required int sort,
    required int width,
    required int height,
  }) =>
      PageBlockData<Product>(
        sort: sort,
        content: Product(
          sku: 'sku_$sort',
          name: '商品名称',
          description: '商品描述',
          price: "¥100.01",
          images: [
            _buildImagePath(
              width,
              height,
            ),
          ],
        ),
      );

  PageBlockData<ImageData> _buildImageBlockData({
    required int sort,
    required int width,
    required int height,
  }) =>
      PageBlockData<ImageData>(
        sort: sort,
        content: ImageData(
          image: _buildImagePath(width, height),
          link: const MyLink(
            type: LinkType.url,
            value: 'https://www.baidu.com',
          ),
        ),
      );

  String _buildImagePath(int width, int height) =>
      '${Constants.placeholderImagePath}/$width/$height';
}
