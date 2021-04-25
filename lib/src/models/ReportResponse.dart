// To parse this JSON data, do
//
//     final reportResponse = reportResponseFromJson(jsonString);

import 'dart:convert';

class ReportResponse {
  ReportResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory ReportResponse.fromRawJson(String str) => ReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
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
    this.totalBuyFromCustomer,
    this.totalSellToHost,
    this.totalRevenue,
    this.totalPendingRequest,
    this.totalHost,
  });

  String balance;
  String totalBuyFromCustomer;
  String totalSellToHost;
  String totalRevenue;
  int totalPendingRequest;
  int totalHost;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    balance: json["balance"] == null ? null : json["balance"],
    totalBuyFromCustomer: json["total_buy_from_customer"] == null ? null : json["total_buy_from_customer"],
    totalSellToHost: json["total_sell_to_host"] == null ? null : json["total_sell_to_host"],
    totalRevenue: json["total_revenue"] == null ? null : json["total_revenue"],
    totalPendingRequest: json["total_pending_request"] == null ? null : json["total_pending_request"],
    totalHost: json["total_host"] == null ? null : json["total_host"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance == null ? null : balance,
    "total_buy_from_customer": totalBuyFromCustomer == null ? null : totalBuyFromCustomer,
    "total_sell_to_host": totalSellToHost == null ? null : totalSellToHost,
    "total_revenue": totalRevenue == null ? null : totalRevenue,
    "total_pending_request": totalPendingRequest == null ? null : totalPendingRequest,
    "total_host": totalHost == null ? null : totalHost,
  };
}
