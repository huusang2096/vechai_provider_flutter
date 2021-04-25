// To parse this JSON data, do
//
//     final sendRequesItems = sendRequesItemsFromJson(jsonString);

import 'dart:convert';

class SendRequesItems {
  List<RequestItem> requestItems;

  SendRequesItems({
    this.requestItems,
  });

  factory SendRequesItems.fromRawJson(String str) => SendRequesItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendRequesItems.fromJson(Map<String, dynamic> json) => SendRequesItems(
    requestItems: json["request_items"] == null ? null : List<RequestItem>.from(json["request_items"].map((x) => RequestItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "request_items": requestItems == null ? null : List<dynamic>.from(requestItems.map((x) => x.toJson())),
  };
}

class RequestItem {
  int scrapId;
  double weight;

  RequestItem({
    this.scrapId,
    this.weight,
  });

  factory RequestItem.fromRawJson(String str) => RequestItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestItem.fromJson(Map<String, dynamic> json) => RequestItem(
    scrapId: json["scrap_id"] == null ? null : json["scrap_id"],
    weight: json["weight"] == null ? null : json["weight"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "scrap_id": scrapId == null ? null : scrapId,
    "weight": weight == null ? null : weight,
  };
}
