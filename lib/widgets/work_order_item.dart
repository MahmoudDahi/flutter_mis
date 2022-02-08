import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mis/providers/work_orders.dart';
import 'package:flutter_mis/remote/constant.dart';
import 'package:flutter_mis/screens/work_order_details_screen.dart';

class WorkOrderItem extends StatelessWidget {
  final String id;
  final String title;
  final String clientName;
  final String employeeName;

  WorkOrderItem(
    Key,
    this.id,
    this.title,
    this.clientName,
    this.employeeName,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (_) {},
      confirmDismiss: (dirction) {
        return showDialog(
            barrierDismissible: false,
            useRootNavigator: false,
            useSafeArea: true,
            context: context,
            builder: (ctx) => SimpleDialog(
                  children: [
                    FutureBuilder(
                        future: Provider.of<WorkOrders>(context, listen: false)
                            .updateWorkOrderStatus(40, id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            Navigator.of(ctx).pop(false);

                          return Constant.loadingProgress(context);
                        }),
                  ],
                ));
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.green[700],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(WorkOrderDetailsScreen.routeName, arguments: id);
        },
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              width: double.infinity,
              height: 1,
            ),
            Row(
              children: [
                Consumer<WorkOrders>(
                  builder: (ctx, workData, _) => Container(
                    height: 90,
                    width: 6,
                    color: Constant.setColor(
                        workData.findByID(id).workOrderStatusId),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '$clientName | $employeeName',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<WorkOrders>(
                    builder: (ctx, workData, _) => Icon(
                      Icons.arrow_forward_ios,
                      color: Constant.setColor(
                          workData.findByID(id).workOrderStatusId),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              width: double.infinity,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
