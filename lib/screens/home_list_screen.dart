import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mis/screens/change_password_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter_mis/providers/app_language.dart';
import 'package:flutter_mis/screens/work_orders_screen.dart';
import 'package:flutter_mis/widgets/home_item.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:flutter_mis/screens/custody_screen.dart';
import 'package:flutter_mis/screens/attatchments_screen.dart';
import 'package:flutter_mis/screens/clients_screen.dart';

class HomeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _mainListItem = [
      if (Provider.of<User>(context).role == Role.Admin)
        {
          'item': {
            'title': AppLocalizations.of(context).workOrder,
            'hint': AppLocalizations.of(context).all,
            'icon': 'assets/images/work_order.png',
            'routeName': WorkOrdersScreen.routeName,
            'argument': Role.Admin
          },
        },
      {
        'item': {
          'title': AppLocalizations.of(context).workOrder,
          'hint': AppLocalizations.of(context).specific,
          'icon': 'assets/images/work_order.png',
          'routeName': WorkOrdersScreen.routeName,
          'argument': Role.Empolyee
        },
      },
      {
        'item': {
          'title': AppLocalizations.of(context).custody,
          'hint': '',
          'icon': 'assets/images/custody.png',
          'routeName': CustodyScreen.routeName
        },
      },
      {
        'item': {
          'title': AppLocalizations.of(context).attachments,
          'hint': '',
          'icon': 'assets/images/attachment.png',
          'routeName': AttatchmentsScreen.routeName
        },
      },
      {
        'item': {
          'title': AppLocalizations.of(context).clients,
          'hint': '',
          'icon': 'assets/images/clients.png',
          'routeName': ClientsScreen.routeName,
        },
      },
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopupMenuButton(
                            icon: Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(AppLocalizations.of(context)
                                        .change_language)
                                  ],
                                ),
                                onTap: () => Provider.of<AppLanguage>(context,
                                        listen: false)
                                    .changeLanguage(),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.password_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(AppLocalizations.of(context)
                                        .change_password)
                                  ],
                                ),
                              value: 1,
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(AppLocalizations.of(context).logout)
                                  ],
                                ),
                                onTap: () {
                                  Provider.of<User>(context, listen: false)
                                      .logout();
                                },
                              ),
                            ],
                            onSelected: (value){
                              if(value ==1){
                                 Navigator.of(context).pushNamed(
                                      ChangePasswordScreen.routeName);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              AppLocalizations.of(context).welcome,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              Provider.of<User>(context, listen: false)
                                  .empolyeeName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 42,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(
                              Provider.of<User>(context, listen: false)
                                  .profileImage),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowIndicator();
                    return;
                  },
                  child: ListView(
                    children: _mainListItem.map((item) {
                      return MainItem(item['item']);
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
