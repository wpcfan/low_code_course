import 'package:common/common.dart';
import 'package:flutter/material.dart';

class PageTableFooterWidget extends StatelessWidget {
  final Function()? onFirstPage;
  final Function()? onPreviousPage;
  final Function()? onNextPage;
  final Function()? onLastPage;
  final int totalSize;
  final int totalPage;
  final int currentPage;
  final IconData firstPageIcon;
  final IconData previousPageIcon;
  final IconData nextPageIcon;
  final IconData lastPageIcon;
  const PageTableFooterWidget({
    super.key,
    this.onFirstPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onLastPage,
    this.totalSize = 0,
    this.totalPage = 0,
    this.currentPage = 0,
    this.firstPageIcon = Icons.first_page,
    this.previousPageIcon = Icons.navigate_before,
    this.nextPageIcon = Icons.navigate_next,
    this.lastPageIcon = Icons.last_page,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Text('共计: $totalSize 条记录'),
      const SizedBox(width: 16),
      Text('页码: $currentPage/$totalPage'),
      const SizedBox(width: 16),
      IconButton(
        onPressed: onFirstPage,
        icon: Icon(firstPageIcon),
      ),
      IconButton(
        onPressed: onPreviousPage,
        icon: Icon(previousPageIcon),
      ),
      IconButton(
        onPressed: onNextPage,
        icon: Icon(nextPageIcon),
      ),
      IconButton(
        onPressed: onLastPage,
        icon: Icon(lastPageIcon),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
