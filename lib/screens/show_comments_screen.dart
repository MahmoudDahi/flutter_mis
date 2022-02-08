import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter_mis/providers/comments.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class ShowCommentsScreen extends StatefulWidget {
  static const routeName = 'show-comments';

  @override
  State<ShowCommentsScreen> createState() => _ShowCommentsScreenState();
}

class _ShowCommentsScreenState extends State<ShowCommentsScreen> {
  static const _pageSize = 10;

  final PagingController<int, CommentItem> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    final woID = ModalRoute.of(context).settings.arguments as String;
    try {
      final newItems = await Comments().fetchData(woID, pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).view_comments),
      ),
      body: PagedListView<int, CommentItem>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (ctx, item, index) {
            return Padding(
              padding: index == 0
                  ? const EdgeInsets.only(top: 10, right: 10, left: 10)
                  : const EdgeInsets.symmetric(horizontal: 10),
              child: Comment(item),
            );
          },
          noItemsFoundIndicatorBuilder: (ctx) => Center(
            child: Image.asset(
              'assets/images/no_data_found.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final CommentItem item;
  Comment(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Theme.of(context).colorScheme.primary.withOpacity(.1),
        ),
        Text(
          DateFormat('dd / MM / yyyy').format(item.dateTime),
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          item.emplyeeName,
          style: Theme.of(context).textTheme.headline1,
        ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context).comment,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              item.message,
              softWrap: true,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary.withOpacity(.1),
        ),
      ],
    );
  }
}
