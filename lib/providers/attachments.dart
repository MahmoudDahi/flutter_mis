import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';

class DownloadAttachmentItem {
  final String name;
  final String mimeType;
  final String data;
  final String extension;

  DownloadAttachmentItem.fromJson(Map<String, dynamic> json)
      : name = json['friendlyName'],
        mimeType = json['mimeType'],
        extension = json['extension'],
        data = json['base64'];
}

class Attachment {
  final int id;
  final String name;
  final String typeTitle;
  final String mimeType;
  final String comment;
  final String clientName;
  final String attachmentUrl;

  Attachment.fromJson(Map<String, dynamic> json)
      : id = json['attachmentId'],
        name = json['friendlyName'],
        attachmentUrl = json['attachmentUrl'],
        typeTitle = json['typeTitle'],
        clientName = json['clientName'],
        mimeType = json['mimeType'],
        comment = json['comment'];
}

class Attachments with ChangeNotifier {
  final _api = '${Constant.Api}/Attachments';
  List<Attachment> _items = [];

  List<Attachment> get items => [..._items];

  Attachment findByID(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<DownloadAttachmentItem> downloadAttatchment(int attatchId) async {
    final url = Uri.parse('$_api/GetById?attachmentID=$attatchId');

    try {
      final response = await http.get(url);
      final success = json.decode(response.body)['success'] as bool;
      if (!success) throw 'Could not download';
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;
      return DownloadAttachmentItem.fromJson(fetchData.first);
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetData({
  
    int clientId,
  }) async {
    _items = [];
    var url;
    if (clientId != null)
      url = Uri.parse('$_api/Client?clientId=$clientId');
    else
      url = Uri.parse('$_api/Admin');

    try {
      final response = await http.get(url);
      final fetchData = json.decode(response.body)['data'] as List<dynamic>;
      fetchData.forEach((json) => _items.add(Attachment.fromJson(json)));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
