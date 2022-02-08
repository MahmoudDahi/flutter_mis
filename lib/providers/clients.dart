import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';

class Client {
  final String id;
  final String name;
  final String address;
  final String fileNumber;
  final String taxRegistration;
  final String PortalUserName;
  final String hisMissionary;
  final String logoUrl;
  final String mail;
  final DateTime dateTime;
  final String phoneNumber;
  final String telephone;
  final String webSite;

  Client.fromJson(Map<String, dynamic> json)
      : id = json['clientId'].toString(),
        name = json['clientName'],
        address = json['address'],
        fileNumber = json['fileNo'],
        taxRegistration = json['uuid'],
        phoneNumber = json['phoneNumber'],
        telephone = json['telephone'],
        PortalUserName = json['portalUsername'],
        logoUrl = json['logoUrl'],
        mail = json['mail'],
        webSite = json['webSite'],
        dateTime = DateTime.tryParse(json['foundationDate']),
        hisMissionary = json['authority'];
}

class Clients with ChangeNotifier {
  static const _API = '${Constant.Api}/Clients';
  List<Client> _items = [];

  List<Client> get items => [..._items];

  Client findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetData() async {
    if (_items.isNotEmpty) return;

    final url = Uri.parse(_API);
    List<Client> loadingData = [];
    try {
      final response = await http.get(url);
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) {
        loadingData.add(Client.fromJson(json));
      });

      _items = loadingData;
      notifyListeners();
    } catch (error) {
      throw (error);
    } finally {
      loadingData = null;
    }
  }
}
