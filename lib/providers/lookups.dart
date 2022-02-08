import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_mis/remote/constant.dart';
import 'package:http/http.dart' as http;

class Status {
  final int statusId;
  final String statusTitle;

  Status.fromJson(Map<String, dynamic> json)
      : statusId = json['statusId'],
        statusTitle = json['statusTitle'];
}

class Priority {
  final int id;
  final String name;

  Priority.fromJson(Map<String, dynamic> json)
      : id = json['pid'],
        name = json['priorityName'];
}

class Location {
  final int id;
  final String title;

  Location.fromJson(Map<String, dynamic> json)
      : id = json['plocationId'],
        title = json['plocationTitle'];
}

class Empolyee {
  final int id;
  final String name;

  Empolyee.fromJson(Map<String, dynamic> json)
      : id = json['employeeId'],
        name = json['emplyeeName'];
}

class Lookups with ChangeNotifier {
  static const _API = '${Constant.Api}/Lookups/';
  final List<Status> _statusList = [];
  final List<Priority> _priorityList = [];
  final List<Location> _locationList = [];
  final List<Empolyee> _empolyeeList = [];

  List<Status> get statusList => [..._statusList];
  List<Priority> get priorityList => [..._priorityList];
  List<Location> get locationList => [..._locationList];
  List<Empolyee> get empolyeeList => [..._empolyeeList];

//get status list from api once
  Future<void> fatchAndSetStatusList() async {
    if (!_statusList.isEmpty) return;
    final url = Uri.parse('${_API}WorkOrders/WorkOrderStatusList');

    try {
      final response = await http.get(url);
      final fetchData = jsonDecode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) {
        _statusList.add(Status.fromJson(json));
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

//get Priority list from api once
  Future<void> fatchAndSetPriorityList() async {
    if (!_priorityList.isEmpty) return;
    final url = Uri.parse('${_API}WorkOrders/PriorityList');

    try {
      final response = await http.get(url);
      final fetchData = jsonDecode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) {
        _priorityList.add(Priority.fromJson(json));
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

//get Location list from api once
  Future<void> fatchAndSetLocationList() async {
    if (!_locationList.isEmpty) return;
    final url = Uri.parse('${_API}WorkOrders/WorkOrderLocationList');

    try {
      final response = await http.get(url);
      final fetchData = jsonDecode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) {
        _locationList.add(Location.fromJson(json));
      });
      notifyListeners();
    } catch (error) {
     throw (error);
    }
  }

//get Employee list from api once
  Future<void> fatchAndSetEmployeeList() async {
    if (!_empolyeeList.isEmpty) return;
    final url = Uri.parse('${Constant.Api}/Employees');

    try {
      final response = await http.get(url);
      final fetchData = jsonDecode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) {
        _empolyeeList.add(Empolyee.fromJson(json));
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
