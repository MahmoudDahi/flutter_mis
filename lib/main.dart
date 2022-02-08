import 'package:flutter/material.dart';
import 'package:flutter_mis/remote/push_notification.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './screens/change_password_screen.dart';
import './providers/attachments.dart';
import './providers/custody.dart';
import './providers/user.dart';
import './providers/clients.dart';
import './providers/lookups.dart';
import './providers/app_language.dart';
import './providers/work_orders.dart';
import './screens/clients_screen.dart';
import './screens/custody_filter_screen.dart';
import './screens/custody_screen.dart';
import './screens/login_screen.dart';
import './screens/splash_screen.dart';
import './screens/show_comments_screen.dart';
import './screens/work_order_filter_screen.dart';
import './screens/home_list_screen.dart';
import './screens/work_order_details_screen.dart';
import './screens/work_orders_screen.dart';
import './screens/show_expenses_screen.dart';
import './screens/attatchments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocal();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
      PushNotification().initialise();
    super.initState();
  }

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => User(),
        ),
        ChangeNotifierProvider<AppLanguage>(
          create: (_) => widget.appLanguage,
        ),
        ChangeNotifierProvider<WorkOrders>(
          create: (_) => WorkOrders(),
        ),
        ChangeNotifierProvider<Lookups>(
          create: (_) => Lookups(),
        ),
        ChangeNotifierProvider<Clients>(
          create: (_) => Clients(),
        ),
        ChangeNotifierProvider<Custody>(
          create: (_) => Custody(),
        ),
        ChangeNotifierProvider<Attachments>(
          create: (_) => Attachments(),
        ),
      ],
      child: Consumer<AppLanguage>(builder: (ctx, lang, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: lang.appLocal,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('ar', ''), // Arabic, no country code
          ],
          title: 'Flutter MIS',
          theme: ThemeData(
            textTheme: TextTheme(
              headlineLarge: TextStyle(
                color: Color.fromARGB(255, 38, 51, 166),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline1: TextStyle(
                color: Color.fromARGB(255, 38, 51, 166),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              headline6: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            fontFamily: lang.currentFont,
            backgroundColor: Colors.white,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Color.fromARGB(255, 38, 51, 166),
                  secondary: Color.fromARGB(255, 38, 166, 153),
                  background: Colors.white,
                ),
          ),
          home: Consumer<User>(
            builder: (context, user, _) {
              if (user.isAuth) return HomeListScreen();
              return FutureBuilder<bool>(
                future: user.tryAutoLogin(),
                builder: (context, snapshotLogin) =>
                    snapshotLogin.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : LoginScreen(),
              );
            },
          ),
          routes: {
            WorkOrdersScreen.routeName: (context) => WorkOrdersScreen(),
            WorkOrderDetailsScreen.routeName: (context) =>
                WorkOrderDetailsScreen(),
            ShowExpensesScreen.routeName: (context) => ShowExpensesScreen(),
            ShowCommentsScreen.routeName: (context) => ShowCommentsScreen(),
            CustodyScreen.routeName: (context) => CustodyScreen(),
            ClientsScreen.routeName: (context) => ClientsScreen(),
            AttatchmentsScreen.routeName: (context) => AttatchmentsScreen(),
            CustodyFilterScreen.routeName: (context) => CustodyFilterScreen(),
            ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
            WorkOrderFilterScreen.routeName: (context) =>
                WorkOrderFilterScreen(),
          },
          onUnknownRoute: (context) => MaterialPageRoute(builder: (ctx) {
            return WorkOrdersScreen();
          }),
        );
      }),
    );
  }
}
