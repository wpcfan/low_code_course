import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class CategorySearchDelegate extends SearchDelegate<Category?> {
  /// 定义搜索框右侧的图标按钮
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  /// 定义搜索框左侧的图标按钮
  /// 通常是返回按钮
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /// 定义搜索结果，在这里我们不需要一个展示搜索结果的页面
  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// 定义搜索建议
  /// 通常是一个ListView
  @override
  Widget buildSuggestions(BuildContext context) {
    return RepositoryProvider<CategoryAdminRepository>(
      create: (context) => CategoryAdminRepository(),
      child: Builder(
        builder: (context) => FutureBuilder(
          future:
              context.read<CategoryAdminRepository>().search(keyword: query),
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return _buildSuccessContent(context, snapshot.data ?? []);
            }
            if (snapshot.hasError) {
              return _buildErrorContent();
            }
            return _buildLoadingContent();
          },
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context, List<Category> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final category = items[index];
        return _buildCategoryItem(context, category);
      },
    );
  }

  /// 构建类目项
  Widget _buildCategoryItem(BuildContext context, Category category) {
    return [
      /// 类目
      ListTile(
          title: Text(category.name ?? ''),
          subtitle: Text(category.code ?? ''),
          onTap: () {
            close(context, category);
          }),

      /// 子类目
      if (category.children.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildSuccessContent(context, category.children),
        ),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }

  Center _buildLoadingContent() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorContent() {
    return [
      const Center(child: Text('搜索失败')),
      TextButton(
        onPressed: () {
          query = '';
        },
        child: const Text('重试'),
      )
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }
}
