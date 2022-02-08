import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_mis/dialogs/client_dialog.dart';

class ClientItem extends StatelessWidget {
  final String id;
  final String name;
  final DateTime dateTime;
  final String imageUrl;

  ClientItem(this.id, this.name, this.dateTime, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        showDialog(context: context, builder: (ctx) => ClientDialog(id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/default_logo.png',
                      image: imageUrl != null ? imageUrl : "",
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
                        DateFormat('dd/MM/yyyy').format(dateTime),
                        style: TextStyle(color: Colors.grey),
                      ),
                      FittedBox(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(.1)),
          ],
        ),
      ),
    );
  }
}
