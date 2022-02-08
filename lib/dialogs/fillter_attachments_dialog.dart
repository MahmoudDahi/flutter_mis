import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/clients.dart';
import 'package:provider/provider.dart';

class FilterAttachmentsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: Text(
            AppLocalizations.of(context).search_by_client,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
          ),
        ),
        SizedBox(height: 10,),
        FutureBuilder(
          future:
              Provider.of<Clients>(context, listen: false).fetchAndSetData(),
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
                          label:
                              Text(AppLocalizations.of(context).client_title),
                        ),
                        onChanged: (value) {
                          Navigator.of(context).pop(value);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
