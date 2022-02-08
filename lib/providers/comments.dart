import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';

class CommentItem {
  String id;
  String emplyeeName;
  String message;
  DateTime dateTime;

  CommentItem.fromJson(Map<String, dynamic> json)
      : id = json['commentId'].toString(),
        emplyeeName = json['emplyeeName'],
        message = json['commentContent'],
        dateTime = DateTime.tryParse(json['commentDate']);
}

class Comments {
  static const _api = '${Constant.Api}/Comments';

  
  Future<bool> addNewComment(
    String woId,
    String comment,
    int employeeId,
  ) async {
    final url = Uri.parse(_api);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'commentContent': comment,
            'workOrderID': int.parse(woId),
            'employeeID': employeeId,
          },
        ),
      );

      final success = json.decode(response.body)['success'] as bool;
      return success;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<CommentItem>> fetchData(
    String workOrderId,
    int pageNo,
    int pageSize,
  ) async {
    final url =
        Uri.parse('$_api?woID=$workOrderId&pageNo=$pageNo&pageSize=$pageSize');

    try {
      final response = await http.get(url);
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;
      List<CommentItem> loadingItem = [];
      fetchData.map((json) {
        loadingItem.add(CommentItem.fromJson(json));
      }).toList();

      return loadingItem;
    } catch (error) {
      throw (error);
    }
  }
}
