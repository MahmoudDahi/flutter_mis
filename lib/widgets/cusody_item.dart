import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustodyItem extends StatelessWidget {
  final String title;
  final String clientName;
  final String employeeName;
  final String description;
  final DateTime dateTime;

  CustodyItem(
    key, {
    @required this.title,
    @required this.clientName,
    @required this.employeeName,
    @required this.dateTime,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
          Text(
            DateFormat('dd/MM/yyyy').format(dateTime),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
          Row(
            children: [
              Text(
                AppLocalizations.of(context).client_title,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                clientName == null
                    ? AppLocalizations.of(context).unassigned
                    : clientName,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          Row(
            children: [
              Text(
                AppLocalizations.of(context).employee,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                employeeName == null
                    ? AppLocalizations.of(context).unassigned
                    : employeeName,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
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
                description == null ? '' : description,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
           Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
        ],
      ),
    );
  }
}
