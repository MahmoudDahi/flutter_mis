import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mis/widgets/client_item.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/clients.dart';

class ClientsScreen extends StatefulWidget {
  static const routeName = '/clients-screen';

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  var _isInit = true;
  var _isLoading = false;
  String _errorFound;
  List<Client> clientList;
  List<Client> filterList;

  // changes the filtered name based on search text and sets state.
  void _searchChanged(String searchText) {
    if (searchText != null && searchText.isNotEmpty) {
      setState(() {
        filterList = clientList
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filterList = clientList;
      });
    }
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
  await  Provider.of<Clients>(context, listen: false).fetchAndSetData().then((_) {
      clientList = Provider.of<Clients>(context, listen: false).items;
      filterList = clientList;
      setState(() {
        _errorFound = null;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _errorFound = error.toString();
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchData();
    }
    _isInit = false;
    super.didChangeDependencies();
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
        title: Text(AppLocalizations.of(context).clients),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorFound == null
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(AppLocalizations.of(context).search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: _searchChanged,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            return ClientItem(
                              filterList[index].id,
                              filterList[index].name,
                              filterList[index].dateTime,
                              filterList[index].logoUrl,
                            );
                          }),
                    ),
                  ],
                )
              : Center(
                  child: Image.asset(
                    'assets/images/no_network_connection.png',
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }
}
