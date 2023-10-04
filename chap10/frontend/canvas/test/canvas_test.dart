import 'package:bloc_test/bloc_test.dart';
import 'package:canvas/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockPageAdminRepository extends Mock implements PageAdminRepository {}

class MockPageBlockAdminRepository extends Mock
    implements PageBlockAdminRepository {}

class MockPageBlockDataAdminRepository extends Mock
    implements PageBlockDataAdminRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  setUpAll(() => registerFallbackValue(
        const PageBlock(
          id: 1,
          sort: 1,
          title: 'Block Title',
          type: PageBlockType.imageRow,
          config: BlockConfig(),
          data: [],
        ),
      ));
  group('CanvasBloc', () {
    late CanvasBloc canvasBloc;
    late MockPageAdminRepository pageAdminRepository;
    late MockPageBlockAdminRepository pageBlockAdminRepository;
    late MockPageBlockDataAdminRepository pageBlockDataAdminRepository;
    late MockProductRepository productRepository;

    const pageLayoutId = 1;

    const product = Product(
      id: 1,
      sku: 'SKU_1',
      name: 'Product Name 1',
      description: 'Product Description 1',
      price: "¥100",
      images: ['https://via.placeholder.com/150'],
    );

    const blockConfig = BlockConfig(
      horizontalPadding: 10.0,
      verticalPadding: 20.0,
      blockHeight: 100.0,
      horizontalSpacing: 5.0,
      verticalSpacing: 8.0,
      blockWidth: 200.0,
    );

    const pageBlock1 = PageBlock(
      id: 1,
      sort: 1,
      title: 'Block Title',
      type: PageBlockType.imageRow,
      config: blockConfig,
      data: [
        PageBlockData<ImageData>(
          id: 1,
          sort: 1,
          content: ImageData(
            image: 'image_url',
            link: MyLink(type: LinkType.url, value: 'https://example.com'),
          ),
        ),
      ],
    );

    const waterfallBlock = PageBlock(
        id: 2,
        sort: 2,
        title: 'Block Title',
        config: blockConfig,
        type: PageBlockType.waterfall,
        data: [
          PageBlockData(
              id: 1,
              sort: 1,
              content: Category(
                id: 1,
                name: 'Category Name',
                code: 'category_code',
              ))
        ]);

    const blockToAdd = PageBlock(
      id: 3,
      sort: 3,
      title: 'Block Title',
      type: PageBlockType.imageRow,
      config: blockConfig,
      data: [
        PageBlockData<ImageData>(
          id: 1,
          sort: 1,
          content: ImageData(
            image: 'image_url',
            link: MyLink(type: LinkType.url, value: 'https://example.com'),
          ),
        ),
      ],
    );

    const pageLayout = PageLayout(
      id: pageLayoutId,
      title: 'Page Title',
      platform: Platform.app,
      status: PageStatus.published,
      pageType: PageType.home,
      blocks: [
        pageBlock1,
        waterfallBlock,
      ], // Define your blocks here
      config: PageConfig(
        baselineScreenWidth: 360, // Define your config here
      ),
    );

    final waterfallItems = [product]; // Define your waterfall items here

    final initialState = CanvasState.initial();

    setUp(() {
      pageAdminRepository = MockPageAdminRepository();
      pageBlockAdminRepository = MockPageBlockAdminRepository();
      pageBlockDataAdminRepository = MockPageBlockDataAdminRepository();
      productRepository = MockProductRepository();
      canvasBloc = CanvasBloc(
        pageAdminRepository: pageAdminRepository,
        pageBlockAdminRepository: pageBlockAdminRepository,
        pageBlockDataAdminRepository: pageBlockDataAdminRepository,
        productRepository: productRepository,
      );
    });

    blocTest<CanvasBloc, CanvasState>(
      'emits [CanvasState] when CanvasEventLoaded is added',
      build: () {
        when(() => pageAdminRepository.get(pageLayoutId))
            .thenAnswer((_) async => pageLayout);
        when(() => productRepository.getProductsByCategoryId(
                categoryId: any(named: 'categoryId'),
                pageNum: any(named: 'pageNum'),
                pageSize: any(named: 'pageSize')))
            .thenAnswer((_) async => SliceWrapper<Product>(
                page: 0, size: 10, hasNext: false, items: waterfallItems));
        return canvasBloc;
      },
      act: (bloc) => bloc.add(const CanvasEventLoaded(pageLayoutId)),
      expect: () => [
        initialState.copyWith(status: FetchStatus.loading),
        initialState.copyWith(
          pageLayout: pageLayout,
          waterfallItems: waterfallItems,
          status: FetchStatus.success,
        ),
      ],
    );

    blocTest<CanvasBloc, CanvasState>(
      'emits [CanvasState] when CanvasEventCreateBlock is added',
      build: () {
        when(() =>
                pageBlockAdminRepository.create(pageLayoutId, any<PageBlock>()))
            .thenAnswer((_) async => blockToAdd.copyWith(sort: 2));
        return canvasBloc;
      },
      seed: () => initialState.copyWith(
        pageLayout: pageLayout,
        waterfallItems: waterfallItems,
      ),
      act: (bloc) => bloc.add(const CanvasEventCreateBlock(blockToAdd)),
      expect: () => [
        initialState.copyWith(
          saving: true,
          pageLayout: pageLayout,
          waterfallItems: waterfallItems,
        ),
        initialState.copyWith(
          pageLayout: pageLayout.copyWith(
            blocks: [
              pageBlock1,
              blockToAdd.copyWith(sort: 2),
              waterfallBlock.copyWith(sort: 3),
            ],
          ),
          waterfallItems: waterfallItems,
          saving: false,
        ),
      ],
    );

    blocTest<CanvasBloc, CanvasState>(
      'emits [CanvasState] when CanvasEventDeleteBlock is added',
      build: () {
        when(() => pageBlockAdminRepository.delete(pageLayoutId, any<int>()))
            .thenAnswer((_) async => {});
        return canvasBloc;
      },
      seed: () => initialState.copyWith(
        pageLayout: pageLayout,
        waterfallItems: waterfallItems,
      ),
      act: (bloc) => bloc.add(const CanvasEventDeleteBlock(1)),
      expect: () => [
        initialState.copyWith(
          saving: true,
          pageLayout: pageLayout,
          waterfallItems: waterfallItems,
        ),
        initialState.copyWith(
          pageLayout: pageLayout.copyWith(
            blocks: [waterfallBlock.copyWith(sort: 1)],
          ),
          waterfallItems: waterfallItems,
          saving: false,
        ),
      ],
    );

    // Add more test cases for other events as needed.

    tearDown(() {
      canvasBloc.close();
    });
  });
}
