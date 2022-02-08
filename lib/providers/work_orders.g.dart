// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrderItem _$WorkOrderItemFromJson(Map<String, dynamic> json) {
  return WorkOrderItem(
    id: json['woId'].toString(),
    title: json['title'] as String,
    description: json['description'] as String,
    clientName: json['clientName'] as String,
    emplyeeName: json['emplyeeName'] as String,
    statusTitle: json['statusTitle'] as String,
    locationOrder: json['plocationTitle'] as String,
    locationArea: json['slocationTitle'] as String,
    creationDate: json['creationDate'] as String,
    dueDate: json['dueDate'] as String,
    priorityName: json['priorityName'] as String,
    workOrderStatusId: json['workOrderStatusId'] as int,
  );
}

