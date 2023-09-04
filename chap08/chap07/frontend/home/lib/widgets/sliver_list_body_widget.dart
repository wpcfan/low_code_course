import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/blocs/blocs.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SliverListBodyWidget extends StatelessWidget {
  const SliverListBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const baseScreenWidth = 375.0;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final baselineScreenWidth =
            state.config?.baselineScreenWidth ?? baseScreenWidth;
        final ratio = screenWidth / baselineScreenWidth;
        final blocks = state.blocks;
        final waterfallItems = state.waterfallItems;
        final widgets = blocks.map((e) {
          if (e.type == PageBlockType.imageRow) {
            return SliverToBoxAdapter(
              child: ImageRowWidget(
                items: e.data.map((e) => e.content as ImageData).toList(),
                config: e.config.withRatio(ratio, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
              ),
            );
          } else if (e.type == PageBlockType.banner) {
            return SliverToBoxAdapter(
              child: BannerWidget(
                items: e.data.map((e) => e.content as ImageData).toList(),
                config: e.config.withRatio(ratio, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
              ),
            );
          } else if (e.type == PageBlockType.productRow) {
            return SliverToBoxAdapter(
              child: ProductRowWidget(
                items: e.data.map((e) => e.content as Product).toList(),
                config: e.config.withRatio(ratio, baselineScreenWidth),
                onTap: (value) {
                  debugPrint('onTap: $value');
                },
                addToCart: (value) => debugPrint('addToCart: $value'),
              ),
            );
          } else if (e.type == PageBlockType.waterfall) {
            return WaterfallWidget(
              items: waterfallItems,
              config: e.config.withRatio(ratio, baselineScreenWidth),
              onTap: (value) {
                debugPrint('onTap: $value');
              },
              addToCart: (value) => debugPrint('addToCart: $value'),
            );
          } else {
            return Container();
          }
        }).toList();
        return MultiSliver(
          children: widgets,
        );
      },
    );
  }
}
