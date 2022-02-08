import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:flutter_mis/screens/work_order_filter_screen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/work_orders.dart';
import 'package:flutter_mis/widgets/work_order_item.dart' as WorkItem;
import 'package:flutter_mis/remote/constant.dart';

class WorkOrdersScreen extends StatefulWidget {
  static const routeName = '/work-orders';

  @override
  State<WorkOrdersScreen> createState() => _WorkOrdersScreenState();
}

class _WorkOrdersScreenState extends State<WorkOrdersScreen> {
  static const _pageSize = 10;
  FilterBy _filterBy = FilterBy.none;
  dynamic _filterValue;
  dynamic _secondFilterValue;
  bool _isLoading = true;
  var _role;
  var _empID;

  final PagingController<int, WorkOrderItem> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void didChangeDependencies() {
    if (_isLoading) {
      _role = ModalRoute.of(context).settings.arguments as Role;
      _empID = Provider.of<User>(context, listen: false).empolyeeID;
      _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
      });
    }
    _isLoading = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    print(_empID);
    try {
      final newItems =
          await Provider.of<WorkOrders>(context, listen: false).fetchAndSetData(
        _role,
        _empID,
        pageKey,
        _pageSize,
        _filterBy,
        _filterValue,
        _secondFilterValue,
      );
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
        title: Text(AppLocalizations.of(context).workOrder),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.primary,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _pagingController.refresh();
        },
        child: PagedListView<int, WorkOrderItem>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<WorkOrderItem>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {
              return Container(
                margin: index == 0
                    ? EdgeInsets.only(top: 10, bottom: 8)
                    : EdgeInsets.only(bottom: 8),
                child: WorkItem.WorkOrderItem(
                  ValueKey(item.id),
                  item.id,
                  item.title,
                  item.clientName,
                  item.emplyeeName,
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (ctx) => Image.asset(
              'assets/images/no_data_found.png',
              fit: BoxFit.fill,
            ),
            noMoreItemsIndicatorBuilder: (_) => SizedBox(height: 80),
            firstPageErrorIndicatorBuilder: (ctx)=> Center(
                  child: Image.asset(
                    'assets/images/no_network_connection.png',
                    fit: BoxFit.cover,
                  ),
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.filter_alt_rounded,
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(WorkOrderFilterScreen.routeName, arguments: _role)
              .then((value) {
            if (value != null) {
              final filter = value as Map<String, dynamic>;
              _filterBy = filter['filterBy'] as FilterBy;
              _filterValue = filter['value'];
              _secondFilterValue = filter['secondValue'];
              _pagingController.refresh();
            }
          });
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
