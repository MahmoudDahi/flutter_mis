import 'dart:convert';

import 'package:flutter_mis/remote/constant.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ExpensesItem {
 final String id;
 final double value;
 final String description;
 final DateTime dateTime;

  ExpensesItem.fromJson(Map<String, dynamic> json)
      : id = json['expenseId'].toString(),
        value = json['expenseValue'],
        description = json['description'],
        dateTime = DateTime.tryParse(json['expenseDate']);
}

class Expenses {
  static const _api = '${Constant.Api}/Expense';

  Future<bool> addNewExpenses(
    String woId,
    String description,
    double cost,
    DateTime date,
  ) async {
    final url = Uri.parse(_api);

    try {
      print('next');
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode({
          'expenseValue': cost,
          'description': description,
          'expenseDate':
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date),
          'workOrderId': int.parse(woId),
        }),
      );

      final isSuccess = json.decode(response.body)['success'];
      return isSuccess;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ExpensesItem>> fetchData(String workOrderId) async {
    final url = Uri.parse('$_api?workOrderId=$workOrderId');

    List<ExpensesItem> loadingData = [];

    try {
      final response = await http.get(url);
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;

      await fetchData.map((json) {
        loadingData.add(ExpensesItem.fromJson(json));
      }).toList();

      return loadingData.reversed.toList();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
