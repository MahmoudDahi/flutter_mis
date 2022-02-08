import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';
import 'package:intl/intl.dart';

class CustodyItem {
  final int id;
  final String title;
  final String description;
  final String clientName;
  final String employeeName;
  final DateTime dateTime;

  CustodyItem.fromJson(Map<String, dynamic> json)
      : id = json['custodyId'],
        title = json['custodyTitle'],
        description = json['description'],
        clientName = json['clientName'],
        employeeName = json['emplyeeName'],
        dateTime = DateTime.tryParse(json['custodyDate']);
}

class Custody with ChangeNotifier {
  static const _api = '${Constant.Api}/Custody';

  List<CustodyItem> _items = [];

  List<CustodyItem> get items => [..._items];

  Future<void> fetchAndSetData({
    FilterBy filterBy,
    dynamic value,
    dynamic secondValue,
  }) async {
    _items = [];
    var url;
    if (filterBy == FilterBy.Client)
      url = Uri.parse('$_api/FilterByClient?clientID=$value');
    else if (filterBy == FilterBy.RangeDate) {
      String startDate = DateFormat(Constant.DateFormatAPI).format(value);
      String endDate = DateFormat(Constant.DateFormatAPI).format(secondValue);
      url = Uri.parse(
          '$_api/FilterByCustodyDate?fromDate=$startDate&toDate=$endDate');
    } else
      url = Uri.parse(_api);

    try {
      final response = await http.get(url);
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;

      fetchData.forEach((json) => _items.add(CustodyItem.fromJson(json)));
     
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
