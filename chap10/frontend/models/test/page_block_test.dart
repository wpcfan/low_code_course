import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void testPageBlock() {
  group('PageBlock', () {
    test('fromJson creates correct object', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Block Title',
        'sort': 2,
        'type': 'ImageRow',
        'config': {
          'horizontalPadding': 10.0,
          'verticalPadding': 20.0,
          'blockHeight': 100.0,
          'horizontalSpacing': 5.0,
          'verticalSpacing': 8.0,
          'blockWidth': 200.0,
        },
        'data': [
          {
            'id': 1,
            'sort': 1,
            'content': {
              'image': 'image_url',
              'link': {'type': 'url', 'value': 'https://example.com'},
            }
          },
        ],
      };

      final pageBlock = PageBlock.fromJson(json);

      expect(pageBlock.id, 1);
      expect(pageBlock.title, 'Block Title');
      expect(pageBlock.sort, 2);
      expect(pageBlock.type, PageBlockType.imageRow);

      final config = pageBlock.config;
      expect(config.horizontalPadding, 10.0);
      expect(config.verticalPadding, 20.0);
      expect(config.blockHeight, 100.0);
      expect(config.horizontalSpacing, 5.0);
      expect(config.verticalSpacing, 8.0);
      expect(config.blockWidth, 200.0);

      final data = pageBlock.data;
      expect(data.length, 1);
      expect(data[0].id, 1);
      expect(data[0].content, isA<ImageData>());
    });

    test('fromJson handles unknown block type', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Block Title',
        'sort': 2,
        'type': 'UnknownType',
        'config': {
          'horizontalPadding': 10.0,
          'verticalPadding': 20.0,
          'blockHeight': 100.0,
          'horizontalSpacing': 5.0,
          'verticalSpacing': 8.0,
          'blockWidth': 200.0,
        },
        'data': [
          {
            'id': 1,
            'sort': 1,
            'content': {
              'image': 'image_url',
              'link': {'type': 'url', 'value': 'https://example.com'},
            }
          },
        ],
      };

      expect(() => PageBlock.fromJson(json), throwsException);
    });

    test('toJson converts object to JSON correctly', () {
      final pageBlock = PageBlock(
        id: 1,
        title: 'Block Title',
        sort: 2,
        type: PageBlockType.imageRow,
        config: const BlockConfig(
          horizontalPadding: 10.0,
          verticalPadding: 20.0,
          blockHeight: 100.0,
          horizontalSpacing: 5.0,
          verticalSpacing: 8.0,
          blockWidth: 200.0,
        ),
        data: [
          PageBlockData<ImageData>(
            id: 1,
            sort: 1,
            content: const ImageData(
                image: 'image_url',
                link: MyLink(type: LinkType.url, value: 'https://example.com')),
          ),
        ],
      );

      final json = pageBlock.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Block Title');
      expect(json['sort'], 2);
      expect(json['type'], 'ImageRow');

      final config = json['config'];
      expect(config['horizontalPadding'], 10.0);
      expect(config['verticalPadding'], 20.0);
      expect(config['blockHeight'], 100.0);
      expect(config['horizontalSpacing'], 5.0);
      expect(config['verticalSpacing'], 8.0);
      expect(config['blockWidth'], 200.0);

      final data = json['data'];
      expect(data.length, 1);
      expect(data[0]['id'], 1);
      expect(data[0]['content']['image'], 'image_url');
      expect(data[0]['content']['link']['type'], 'url');
      expect(data[0]['content']['link']['value'], 'https://example.com');
    });

    test('copyWith creates a new object with updated values', () {
      final originalPageBlock = PageBlock(
        id: 1,
        title: 'Block Title',
        sort: 2,
        type: PageBlockType.imageRow,
        config: const BlockConfig(
          horizontalPadding: 10.0,
          verticalPadding: 20.0,
          blockHeight: 100.0,
          horizontalSpacing: 5.0,
          verticalSpacing: 8.0,
          blockWidth: 200.0,
        ),
        data: [
          PageBlockData<ImageData>(
            id: 1,
            sort: 1,
            content: const ImageData(
                image: 'image_url',
                link: MyLink(type: LinkType.url, value: 'https://example.com')),
          ),
        ],
      );

      final updatedPageBlock = originalPageBlock.copyWith(
        title: 'Updated Block Title',
        sort: 3,
        type: PageBlockType.banner,
        config: const BlockConfig(
          horizontalPadding: 15.0,
          verticalPadding: 25.0,
          blockHeight: 120.0,
          horizontalSpacing: 6.0,
          verticalSpacing: 9.0,
          blockWidth: 220.0,
        ),
        data: [
          PageBlockData<ImageData>(
            id: 2,
            sort: 2,
            content: const ImageData(
                image: 'updated_image_url',
                link: MyLink(type: LinkType.url, value: 'https://updated.com')),
          ),
        ],
      );

      expect(updatedPageBlock.id, 1);
      expect(updatedPageBlock.title, 'Updated Block Title');
      expect(updatedPageBlock.sort, 3);
      expect(updatedPageBlock.type, PageBlockType.banner);

      final config = updatedPageBlock.config;
      expect(config.horizontalPadding, 15.0);
      expect(config.verticalPadding, 25.0);
      expect(config.blockHeight, 120.0);
      expect(config.horizontalSpacing, 6.0);
      expect(config.verticalSpacing, 9.0);
      expect(config.blockWidth, 220.0);

      final data = updatedPageBlock.data;
      expect(data.length, 1);
      expect(data[0].id, 2);
      expect(data[0].content, isA<ImageData>());
      expect((data[0].content as ImageData).image, 'updated_image_url');
      expect((data[0].content as ImageData).link.type, LinkType.url);
      expect((data[0].content as ImageData).link.value, 'https://updated.com');
    });
  });
}
