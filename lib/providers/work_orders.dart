import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:flutter_mis/remote/exception_error.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_mis/remote/constant.dart';

part 'work_orders.g.dart';



@JsonSerializable()
class WorkOrderItem {
  @JsonKey(name: 'woId')
  final String id;
  final String title;
  final String description;
  final String clientName;
  final String emplyeeName;
  final String statusTitle;
  @JsonKey(name: 'plocationTitle')
  final String locationOrder;
  @JsonKey(name: 'slocationTitle')
  final String locationArea;
  final String creationDate;
  final String dueDate;
  final String priorityName;
  final int workOrderStatusId;

  WorkOrderItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.clientName,
    @required this.emplyeeName,
    @required this.statusTitle,
    @required this.locationOrder,
    @required this.locationArea,
    @required this.creationDate,
    @required this.dueDate,
    @required this.priorityName,
    @required this.workOrderStatusId,
  });

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderItemFromJson(json);
}

class WorkOrders with ChangeNotifier {
  static const _apiAdmin = '${Constant.Api}/WorkOrders/Admin';
  static const _apiEmployee = '${Constant.Api}/WorkOrders';
  List<WorkOrderItem> _workOrders = [];

  WorkOrderItem findByID(String id) {
    return _workOrders.firstWhere((work) => work.id == id);
  }

  List<WorkOrderItem> get workOrdersList => [..._workOrders];

  Future<WorkOrderItem> singleWorkOrder(int woId) async {
    final url = Uri.parse('$_apiAdmin/WorkOrder?id=$woId');
    try {
      final response = await http.get(url);

      final fetchData = json.decode(response.body)['data'] as List<dynamic>;

      return WorkOrderItem.fromJson(fetchData.first);
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> updateWorkOrderStatus(int status, String workOrderId) async {
    final url = Uri.parse('${Constant.Api}/WorkOrders/ChangeProgress');

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          'status': status,
          'woId': int.parse(workOrderId),
        }),
      );
      final successUpdate = json.decode(response.body)['success'] as bool;
      String message = (json.decode(response.body)['data'] as List<dynamic>)
          .first
          .toString();

      if (!successUpdate) throw (ExceptionError(message));

      final workOrderItem = await singleWorkOrder(int.parse(workOrderId));
      final workIndex =
          _workOrders.indexWhere((element) => element.id == workOrderId);
      _workOrders[workIndex] = workOrderItem;

      notifyListeners();
      return successUpdate;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<WorkOrderItem>> fetchAndSetData(
    Role role,
    int empId,
    int pageNo,
    int pageSize,
    FilterBy filterBy,
    dynamic value,
    dynamic secondValue,
  ) async {
    if (pageNo == 1) _workOrders = [];
   

    var url;
    if (filterBy == FilterBy.none)
    if (role == Role.Admin)
      url = Uri.parse('$_apiAdmin?pageNo=$pageNo&pageSize=$pageSize');
      else 
      url = Uri.parse('$_apiEmployee?pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.Status)
    if(role == Role.Admin)
      url = Uri.parse(
          '$_apiAdmin/FilterByStatus/NoDate?statusId=$value&pageNo=$pageNo&pageSize=$pageSize');
          else 
            url = Uri.parse(
          '$_apiEmployee/FilterByStatus?statusId=$value&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.Priority)
    if(role == Role.Admin)
      url = Uri.parse(
          '$_apiAdmin/FilterByPriority/NoDate?priorityId=$value&pageNo=$pageNo&pageSize=$pageSize');
          else  url = Uri.parse(
          '$_apiEmployee/FilterByPriorityID?priorityId=$value&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.Location)
    if(role == Role.Admin)
      url = Uri.parse(
          '$_apiAdmin/FilterByMasterPlace?masterPlaceID=$value&pageNo=$pageNo&pageSize=$pageSize');
          else 
          url = Uri.parse(
          '$_apiEmployee/FilterByLocation?masterPlaceID=$value&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.Client)
    if(role == Role.Admin)
      url = Uri.parse(
          '$_apiAdmin/FilterByClient?clientID=$value&pageNo=$pageNo&pageSize=$pageSize');
          else 
          url = Uri.parse(
          '$_apiEmployee/FilterByClientID?clientID=$value&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.Employee)
      url = Uri.parse(
          '$_apiAdmin/FilterByEmployee?employeeName=$value&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
    else if (filterBy == FilterBy.RangeDate) {
      String startDate = DateFormat(Constant.DateFormatAPI).format(value);
      String endDate = DateFormat(Constant.DateFormatAPI).format(secondValue);
      if (role == Role.Admin) {
        url = Uri.parse(
            '$_apiAdmin/FilterByExecuationDate?fromDate=$startDate&toDate=$endDate&pageNo=$pageNo&pageSize=$pageSize');
      } else {
        url = Uri.parse(
            '$_apiEmployee/FilterByDueDate?fromDate=$startDate&toDate=$endDate&pageNo=$pageNo&pageSize=$pageSize&empID=$empId');
      }
    } else if (filterBy == FilterBy.Unassigned)
      url = Uri.parse(
          '$_apiAdmin/FilterByUnAssigned/NoDate?pageNo=$pageNo&pageSize=$pageSize&empID=$empId');

    List<WorkOrderItem> loadingData = [];

    try {
      final response = await http.get(url);

      final fetchData = jsonDecode(response.body)['data'];

      fetchData.forEach(
        (json) => loadingData.add(
          WorkOrderItem.fromJson(json),
        ),
      );

      _workOrders.addAll(loadingData);

      // notifyListeners();
      return loadingData;
    } catch (error) {
      print(error);
      throw (error);
    } finally {
      loadingData = null;
    }
  }
}
