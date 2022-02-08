import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/clients.dart';
import 'package:flutter_mis/remote/constant.dart';

class CustodyFilterScreen extends StatelessWidget {
  static const routeName = '/custody-filter';

  Future<void> _fetchData(BuildContext context) async {
    try {
      await Provider.of<Clients>(context, listen: false).fetchAndSetData();
    } catch (error) {
      print(error);
    }
  }

  void _popWithData(ctx, FilterBy filterBy, dynamic value,
      [dynamic secondValue]) {
    Navigator.of(ctx).pop({
      'filterBy': filterBy,
      'value': value,
      'secondValue': secondValue,
    });
  }

  Future<void> _showRangePickerDate(BuildContext ctx) async {
    final datePicker = await showDateRangePicker(
        context: ctx,
        currentDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 1));

    if (datePicker != null) {
      _popWithData(ctx, FilterBy.RangeDate, datePicker.start, datePicker.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).filter),
      ),
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (ctx, futureSnap) {
          if (futureSnap.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Consumer<Clients>(
            builder: (context, clients, child) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField(
                      menuMaxHeight: 300,
                      isExpanded: true,
                      items: clients.items
                          .map(
                            (client) => DropdownMenuItem(
                              child: Text(
                                client.name,
                              ),
                              value: int.parse(client.id),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(AppLocalizations.of(context).client_title),
                      ),
                      onChanged: (value) {
                        _popWithData(ctx, FilterBy.Client, value);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
                      onPressed: () => _showRangePickerDate(context),
                      child: Text(AppLocalizations.of(context).choose_range),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
