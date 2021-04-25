// To parse this JSON data, do
//
//     final createOrderRequest = createOrderRequestFromJson(jsonString);

import 'dart:convert';

class CreateOrderRequest {
  CreateOrderRequest({
    this.requestTime,
    this.requestItems,
  });

  int requestTime;
  List<RequestItemOrder> requestItems;

  factory CreateOrderRequest.fromRawJson(String str) =>
      CreateOrderRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      CreateOrderRequest(
        requestTime: json["request_time"] == null ? null : json["request_time"],
        requestItems: json["request_items"] == null
            ? null
            : List<RequestItemOrder>.from(
                json["request_items"].map((x) => RequestItemOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request_time": requestTime == null ? null : requestTime,
        "request_items": requestItems == null
            ? null
            : List<dynamic>.from(requestItems.map((x) => x.toJson())),
      };
}

class RequestItemOrder {
  RequestItemOrder({
    this.scrapId,
    this.weight,
  });

  int scrapId;
  double weight;

  factory RequestItemOrder.fromRawJson(String str) =>
      RequestItemOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestItemOrder.fromJson(Map<String, dynamic> json) =>
      RequestItemOrder(
        scrapId: json["scrap_id"] == null ? null : json["scrap_id"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "scrap_id": scrapId == null ? null : scrapId,
        "weight": weight == null ? null : weight,
      };
}
