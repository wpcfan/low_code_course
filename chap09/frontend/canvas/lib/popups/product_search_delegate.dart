import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
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
    return RepositoryProvider<ProductAdminRepository>(
      create: (context) => ProductAdminRepository(),
      child: Builder(
        builder: (context) => FutureBuilder(
          future: context.read<ProductAdminRepository>().search(keyword: query),
          builder: (context, AsyncSnapshot<PageWrapper<Product>> snapshot) {
            if (snapshot.hasData) {
              return _buildSuccessContent(snapshot);
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

  ListView _buildSuccessContent(AsyncSnapshot<PageWrapper<Product>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.items.length,
      itemBuilder: (context, index) {
        final item = snapshot.data!.items[index];
        return ListTile(
          title: Text(item.name ?? ''),
          subtitle: Text(item.description ?? ''),
          leading: Image.network(
            item.images.first,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          trailing: Text(
            item.price ?? '',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}
