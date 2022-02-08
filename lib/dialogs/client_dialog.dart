import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'package:flutter_mis/providers/clients.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Launch {
  Call,
  Web,
  Copy,
  Open,
}

class ClientDialog extends StatelessWidget {
  final String id;

  ClientDialog(this.id);

  Widget _itemInRow(BuildContext context, String title, String value,
      {Launch launchOption}) {
    final TextValue = Text(
      value != null ? value : '',
      softWrap: true,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      maxLines: 1,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(width: 10),
        Expanded(
          child: launchOption != null
              ? value != null && value.isNotEmpty
                  ? PopupMenuButton(
                      child: TextValue,
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          child: Text(AppLocalizations.of(context).copy),
                          value: Launch.Copy,
                        ),
                        PopupMenuItem(
                          child: Text(launchOption == Launch.Call
                              ? AppLocalizations.of(context).call
                              : AppLocalizations.of(context).visit_website),
                          value: Launch.Open,
                        ),
                      ],
                      onSelected: (option) {
                        if (option == Launch.Copy) {
                          Clipboard.setData(ClipboardData(text: value)).then(
                            (_) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green[500],
                                content: Text(AppLocalizations.of(context)
                                    .copied_success),
                              ),
                            ),
                          );
                        } else {
                          _clickOnText(context, launchOption, value);
                        }
                      },
                    )
                  : TextValue
              : TextValue,
        ),
      ],
    );
  }

  void _clickOnText(
      BuildContext context, Launch launchOption, String value) async {
    try {
      await launcher.launch(
        launchOption == Launch.Call ? 'tel:$value' : value,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(AppLocalizations.of(context).couldnot_open),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Clients>(context, listen: false).findById(id);
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 12),
      contentPadding: EdgeInsets.all(12),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/default_logo.png',
                      image: client.logoUrl != null ? client.logoUrl : "",
                      imageErrorBuilder: (ctx, obj, st) =>
                          Image.asset('assets/images/default_logo.png'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(client.dateTime),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        client.name,
                        style: Theme.of(context).textTheme.headline1,
                        softWrap: true,
                      ),
                      Text(
                        client.address != null ? client.address : '',
                        style: TextStyle(color: Colors.grey),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _itemInRow(context, AppLocalizations.of(context).file_number,
                client.fileNumber),
            SizedBox(height: 2),
            _itemInRow(
                context,
                AppLocalizations.of(context).tax_registration_number,
                client.taxRegistration),
            SizedBox(height: 2),
            _itemInRow(context, AppLocalizations.of(context).his_missionary,
                client.hisMissionary),
            SizedBox(height: 2),
            _itemInRow(context, AppLocalizations.of(context).portal_username,
                client.PortalUserName),
            SizedBox(height: 2),
            _itemInRow(
                context, AppLocalizations.of(context).email, client.mail),
            SizedBox(height: 2),
            _itemInRow(context, AppLocalizations.of(context).phone_number,
                client.phoneNumber,
                launchOption: Launch.Call),
            SizedBox(height: 2),
            _itemInRow(context, AppLocalizations.of(context).telephone,
                client.telephone,
                launchOption: Launch.Call),
            SizedBox(height: 2),
            _itemInRow(
                context, AppLocalizations.of(context).website, client.webSite,
                launchOption: Launch.Web),
            SizedBox(height: 12),
          ],
        )
      ],
    );
  }
}
