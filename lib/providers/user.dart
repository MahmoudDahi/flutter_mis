import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_mis/remote/exception_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';

enum Role {
  Admin,
  Empolyee,
}

class User with ChangeNotifier {
  int _id;
  String _name;
  int _roleId;
  int _empId;
  String _employeeName;
  String _profileImage;

  void _fromjson(Map<String, Object> json) {
    _id = json['userId'];
    _name = json['userName'];
    _roleId = json['roleId'];
    _empId = json['empId'];
    _employeeName = json['employeeName'];
    _profileImage = json['profileImage'];
  }

  Map<String, Object> _toJson() => {
        'userId': _id,
        'userName': _name,
        'roleId': _roleId,
        'empId': _empId,
        'employeeName': _employeeName,
        'profileImage': _profileImage,
      };

  static const _API = '${Constant.Api}/Account';

  int get empolyeeID => _empId;
  String get empolyeeName => _employeeName;

  Uint8List get profileImage => Base64Codec().decode(_profileImage);

  Role get role {
    if (_roleId == 1) return Role.Admin;
    return Role.Empolyee;
  }

  bool get isAuth => _id != null;

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final url = Uri.parse('$_API/ChangePassword');
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "newPassword": newPassword,
          "userId": _id,
        }),
        headers: {
          "content-type": "application/json",
          "LoginCookie": "$_name-$currentPassword",
        },
      );
      final isSuccess = json.decode(response.body)['success'] as bool;
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;
      if (!isSuccess) throw ExceptionError(fetchData.first);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _fromjson(userData);

    notifyListeners();

    return true;
  }

  Future<void> login(
    String userName,
    String password,
  ) async {
    final url = Uri.parse('$_API/Login');
    try {
      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "LoginCookie": "$userName-$password",
        },
      );
      final authCheck = json.decode(response.body)['success'] as bool;

      if (!authCheck) throw (json.decode(response.body)['msg']);

      final fetchData = json.decode(response.body)['data'] as List<dynamic>;

      _fromjson(fetchData.first);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode(
          _toJson(),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> logout() async {
    _id = null;
    _name = null;
    _empId = null;
    _employeeName = null;
    _profileImage = null;
    _roleId = null;

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
    notifyListeners();
  }
}
