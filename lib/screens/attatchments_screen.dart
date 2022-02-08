import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/attachments.dart';
import '../dialogs/fillter_attachments_dialog.dart';
import '../widgets/attachment_item.dart';

class AttatchmentsScreen extends StatefulWidget {
  static const routeName = '/attatchments-screen';

  @override
  _AttatchmentsScreenState createState() => _AttatchmentsScreenState();
}

class _AttatchmentsScreenState extends State<AttatchmentsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _errorFound;
  List<Attachment> attatchmentList;
  List<Attachment> filterList;

  // changes the filtered name based on search text and sets state.
  void _searchChanged(String searchText) {
    if (searchText != null && searchText.isNotEmpty) {
      setState(() {
        filterList = attatchmentList
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filterList = attatchmentList;
      });
    }
  }

  Future<void> _fetchData({int clientID}) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Attachments>(context, listen: false)
        .fetchAndSetData(clientId: clientID)
        .then((_) {
      attatchmentList = Provider.of<Attachments>(context, listen: false).items;
      filterList = attatchmentList;
      setState(() {
        _isLoading = false;
        _errorFound = null;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _errorFound = error;
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
        title: Text(AppLocalizations.of(context).attachments),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _errorFound == null
                ? attatchmentList.isEmpty
                    ? Center(
                        child: Image.asset('assets/images/no_data_found.png'))
                    : Column(
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
                                label:
                                    Text(AppLocalizations.of(context).search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onChanged: _searchChanged,
                            ),
                          ),
                          Expanded(
                            child: filterList.isEmpty
                                ? Center(
                                    child: Image.asset(
                                        'assets/images/no_data_found.png'))
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 80),
                                    itemCount: filterList.length,
                                    itemBuilder: (context, index) {
                                      return AttachmentItem(
                                          filterList[index].id);
                                    },
                                  ),
                          ),
                        ],
                      )
                : Center(
                    child: Image.asset(
                      'assets/images/no_network_connection.png',
                      fit: BoxFit.cover,
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_alt),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => FilterAttachmentsDialog(),
          ).then((value) {
            if (value != null) {
              _fetchData(clientID: value);
            }
          });
        },
      ),
    );
  }
}
