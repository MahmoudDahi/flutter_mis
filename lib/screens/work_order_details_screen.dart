import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


import 'package:flutter_mis/dialogs/add_comment_dialog.dart';
import 'package:flutter_mis/dialogs/add_expenses_dialog.dart';
import 'package:flutter_mis/dialogs/change_status_dialog.dart';
import 'package:flutter_mis/remote/constant.dart';
import 'package:flutter_mis/screens/show_comments_screen.dart';
import 'package:flutter_mis/screens/show_expenses_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/work_orders.dart';

enum WorkOrderMenu {
  viewExpenses,
  addExpenses,
  viewComment,
  addComment,
  changeStatus,
}

class WorkOrderDetailsScreen extends StatelessWidget {
  static const routeName = '/work-order-details';

  void _showDialogChangeStatus(
      BuildContext context, String workOrderId, WorkOrderMenu menu) {
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          if (menu == WorkOrderMenu.changeStatus)
            return ChangeStatusDialog(ctx, workOrderId);
          if (menu == WorkOrderMenu.addExpenses)
            return AddExpensesDialog(ctx, workOrderId);
          return AddCommentDialog(ctx, workOrderId);
        });
  }

  void _NavigatedToScreen(
      BuildContext context, String routeName, String workOrderId) {
    Navigator.of(context).pushNamed(routeName, arguments: workOrderId);
  }

  @override
  Widget build(BuildContext context) {
    final woId = ModalRoute.of(context).settings.arguments as String;
    print(woId);
    final workOrder =
        Provider.of<WorkOrders>(context, listen: false).findByID(woId);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).workOrder),
        actions: [
          PopupMenuButton<WorkOrderMenu>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => <PopupMenuEntry<WorkOrderMenu>>[
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).view_expenses),
                value: WorkOrderMenu.viewExpenses,
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).add_expenses),
                value: WorkOrderMenu.addExpenses,
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).view_comments),
                value: WorkOrderMenu.viewComment,
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).add_comments),
                value: WorkOrderMenu.addComment,
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).change_status),
                value: WorkOrderMenu.changeStatus,
              ),
            ],
            onSelected: (menu) {
              if (menu == WorkOrderMenu.viewExpenses)
                return _NavigatedToScreen(
                    context, ShowExpensesScreen.routeName, woId);
              if (menu == WorkOrderMenu.viewComment)
                return _NavigatedToScreen(
                    context, ShowCommentsScreen.routeName, woId);

              return _showDialogChangeStatus(context, woId, menu);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  workOrder.title,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Text(
                AppLocalizations.of(context).client_title,
              ),
              Text(workOrder.clientName,
                  style: Theme.of(context).textTheme.headline1),
              Divider(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
              Text(
                AppLocalizations.of(context).address_title,
              ),
              Text('${workOrder.locationOrder} - ${workOrder.locationArea}',
                  style: Theme.of(context).textTheme.headline1),
              Text(
                AppLocalizations.of(context).date_title,
              ),
              Text(
                  DateFormat('yyyy / MM / dd')
                      .format(DateTime.tryParse(workOrder.dueDate)),
                  style: Theme.of(context).textTheme.headline1),
              Divider(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
              Text(
                AppLocalizations.of(context).assigned_to,
              ),
              Text(workOrder.emplyeeName,
                  style: Theme.of(context).textTheme.headline1),
              Divider(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).priority,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(workOrder.priorityName,
                        style: Theme.of(context).textTheme.headline1),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).status,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Consumer<WorkOrders>(
                      builder: (_, workData, __) => Text(
                        workData.findByID(woId).statusTitle,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Constant.setColor(
                                workData.findByID(woId).workOrderStatusId)),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
              Text(
                AppLocalizations.of(context).description,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  Bidi.stripHtmlIfNeeded(workOrder.description),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
