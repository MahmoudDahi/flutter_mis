import 'package:flutter/material.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/clients.dart';
import 'package:flutter_mis/providers/lookups.dart';
import 'package:flutter_mis/remote/constant.dart';

class WorkOrderFilterScreen extends StatelessWidget {
  static const routeName = '/work-order-filter';

  Future<void> _fetchData(
    BuildContext context,
  ) async {
    try {
      final lookups = Provider.of<Lookups>(context, listen: false);
      await lookups.fatchAndSetStatusList();
      await lookups.fatchAndSetPriorityList();
      await lookups.fatchAndSetLocationList();
      await lookups.fatchAndSetEmployeeList();
      await Provider.of<Clients>(context, listen: false).fetchAndSetData();
    } catch (error) {
      print(error);
    }
  }

  void _popWithData(BuildContext ctx, FilterBy filterBy,
      [dynamic value, dynamic secondValue]) {
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
    final isAdmin =
        (ModalRoute.of(context).settings.arguments as Role) == Role.Admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).filter),
      ),
      body: FutureBuilder(
          future: _fetchData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Consumer<Lookups>(
                      builder: (ctx, lookup, _) {
                         final statusList = lookup.statusList;
                statusList.removeWhere((element) => element.statusId == 10);
                        return DropdownButtonFormField(
                          isExpanded: true,
                          items: statusList
                              .map(
                                (status) => DropdownMenuItem(
                                  child: Text(
                                    status.statusTitle,
                                  ),
                                  value: status.statusId,
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(AppLocalizations.of(context).status),
                          ),
                          onChanged: (value) {
                            _popWithData(ctx, FilterBy.Status, value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<Lookups>(
                      builder: (ctx, lookup, _) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          items: lookup.priorityList
                              .map(
                                (priority) => DropdownMenuItem(
                                  child: Text(
                                    priority.name,
                                  ),
                                  value: priority.id,
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(AppLocalizations.of(context).priority),
                          ),
                          onChanged: (value) {
                            _popWithData(ctx, FilterBy.Priority, value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<Lookups>(
                      builder: (ctx, lookup, _) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          items: lookup.locationList
                              .map(
                                (location) => DropdownMenuItem(
                                  child: Text(
                                    location.title,
                                  ),
                                  value: location.id,
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(AppLocalizations.of(context).address),
                          ),
                          onChanged: (value) {
                            _popWithData(ctx, FilterBy.Location, value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<Clients>(
                      builder: (ctx, clients, _) {
                        return DropdownButtonFormField(
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
                            label:
                                Text(AppLocalizations.of(context).client_title),
                          ),
                          onChanged: (value) {
                            _popWithData(ctx, FilterBy.Client, value);
                          },
                        );
                      },
                    ),
                    if (isAdmin) SizedBox(height: 10),
                    if (isAdmin)
                      Consumer<Lookups>(
                        builder: (ctx, lookup, _) {
                          return DropdownButtonFormField(
                            menuMaxHeight: 200,
                            isExpanded: true,
                            items: lookup.empolyeeList
                                .map(
                                  (empolyee) => DropdownMenuItem(
                                    child: Text(
                                      empolyee.name,
                                    ),
                                    value: empolyee.name,
                                  ),
                                )
                                .toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label:
                                  Text(AppLocalizations.of(context).employee),
                            ),
                            onChanged: (value) {
                              _popWithData(ctx, FilterBy.Employee, value);
                            },
                          );
                        },
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12)),
                        onPressed: () => _showRangePickerDate(context),
                        child: Text(AppLocalizations.of(context).choose_range)),
                    SizedBox(height: 10),
                    if (isAdmin)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            _popWithData(context, FilterBy.Unassigned);
                          },
                          child: Text(AppLocalizations.of(context).unassigned)),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
