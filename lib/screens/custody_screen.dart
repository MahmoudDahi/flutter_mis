import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/custody.dart' show Custody;
import 'package:flutter_mis/remote/constant.dart';
import 'package:flutter_mis/screens/custody_filter_screen.dart';
import 'package:flutter_mis/widgets/cusody_item.dart';
import 'package:provider/provider.dart';

class CustodyScreen extends StatefulWidget {
  static const routeName = '/custody-screen';

  @override
  State<CustodyScreen> createState() => _CustodyScreenState();
}

class _CustodyScreenState extends State<CustodyScreen> {
  var _errorFound;
  FilterBy filterBy = FilterBy.none;
  dynamic firstValue;
  dynamic secondValue;

  Future<void> _fetchData(BuildContext ctx) async {
    try {
      await Provider.of<Custody>(ctx, listen: false).fetchAndSetData(
        filterBy: filterBy,
        value: firstValue,
        secondValue: secondValue,
      );
      _errorFound = null;
    } catch (error) {
      _errorFound = error.toString();
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text(AppLocalizations.of(context).custody),
      ),
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (ctx, futureSnapCustody) {
          if (futureSnapCustody.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return RefreshIndicator(
            onRefresh: () => _fetchData(context),
            child: _errorFound == null
                ? Consumer<Custody>(builder: (ctx, custody, _) {
                    final custodyList = custody.items.reversed.toList();
                    return custodyList.isEmpty
                        ? Center(
                            child: Image.asset(
                              'assets/images/no_data_found.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        : ListView.builder(
                            itemCount: custodyList.length,
                            itemBuilder: (context, index) => CustodyItem(
                              ValueKey(custodyList[index].id),
                              title: custodyList[index].title,
                              clientName: custodyList[index].clientName,
                              employeeName: custodyList[index].employeeName,
                              dateTime: custodyList[index].dateTime,
                              description: custodyList[index].description,
                            ),
                          );
                  })
                : Center(
                    child: Image.asset(
                      'assets/images/no_network_connection.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_alt),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CustodyFilterScreen.routeName)
              .then((value) {
            if (value != null) {
              final fetchData = value as Map<String, dynamic>;
              filterBy = fetchData['filterBy'];
              firstValue = fetchData['value'];
              secondValue = fetchData['secondValue'];
              setState(() {});
            }
          });
        },
      ),
    );
  }
}
