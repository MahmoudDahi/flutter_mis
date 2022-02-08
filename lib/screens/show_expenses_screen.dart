import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/expenses.dart';
import 'package:intl/intl.dart';

class ShowExpensesScreen extends StatelessWidget {
  static const routeName = '/show-expenses';

  @override
  Widget build(BuildContext context) {
    final woId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).view_expenses),
      ),
      body: FutureBuilder<List<ExpensesItem>>(
        future: Expenses().fetchData(woId),
        builder: (ctx, futureSnap) {
          if (futureSnap.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          final data = futureSnap.data;
          if (data.isEmpty)
            return Center(
              child: Image.asset(
                'assets/images/no_data_found.png',
                fit: BoxFit.cover,
              ),
            );

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: index == 0
                    ? const EdgeInsets.only(top: 10, left: 10, right: 10)
                    : const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.1),
                    ),
                    Text(
                      DateFormat('dd / MM / yyyy').format(data[index].dateTime),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).cost,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${data[index].value} ${AppLocalizations.of(context).bound}',
                          softWrap: true,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).description,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          data[index].description,
                          softWrap: true,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                    Divider(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.1),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
