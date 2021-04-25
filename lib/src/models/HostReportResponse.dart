// To parse this JSON data, do
//
//     final hostReportResponse = hostReportResponseFromJson(jsonString);

import 'dart:convert';

class HostReportResponse {
  HostReportResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory HostReportResponse.fromRawJson(String str) => HostReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostReportResponse.fromJson(Map<String, dynamic> json) => HostReportResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.balance,
    this.totalBuyRequests,
    this.totalHost,
  });

  String balance;
  int totalBuyRequests;
  int totalHost;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    balance: json["balance"] == null ? null : json["balance"],
    totalBuyRequests: json["total_buy_requests"] == null ? null : json["total_buy_requests"],
    totalHost: json["total_host"] == null ? null : json["total_host"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance == null ? null : balance,
    "total_buy_requests": totalBuyRequests == null ? null : totalBuyRequests,
    "total_host": totalHost == null ? null : totalHost,

  };
}
