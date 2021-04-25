// To parse this JSON data, do
//
//     final multiOrderRequest = multiOrderRequestFromJson(jsonString);

import 'dart:convert';

class MultiOrderRequest {
  MultiOrderRequest({
    this.requestIds,
  });

  List<int> requestIds = new List();

  factory MultiOrderRequest.fromRawJson(String str) => MultiOrderRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MultiOrderRequest.fromJson(Map<String, dynamic> json) => MultiOrderRequest(
    requestIds: json["request_ids"] == null ? null : List<int>.from(json["request_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "request_ids": requestIds == null ? null : List<dynamic>.from(requestIds.map((x) => x)),
  };
}
