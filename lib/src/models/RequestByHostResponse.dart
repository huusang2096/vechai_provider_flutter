// To parse this JSON data, do
//
//     final requestByHostResponse = requestByHostResponseFromJson(jsonString);

import 'dart:convert';

import 'OrderResponse.dart';


class RequestByHostResponse {
  bool success;
  String message;
  HostOrder hostOrder;

  RequestByHostResponse({
    this.success,
    this.message,
    this.hostOrder,
  });

  factory RequestByHostResponse.fromRawJson(String str) => RequestByHostResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestByHostResponse.fromJson(Map<String, dynamic> json) => RequestByHostResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    hostOrder: json["data"] == null ? null : HostOrder.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": hostOrder == null ? null : hostOrder.toJson(),
  };
}

class HostOrder {
  int id;
  int requestTime;
  Address address;
  Host host;
  dynamic collector;
  int createdAt;
  String status;
  dynamic approveAt;
  List<RequestItem> requestItems;
  String grandTotalAmount;
  String amountWallet;
  String amountCash;


  HostOrder({
    this.id,
    this.requestTime,
    this.address,
    this.host,
    this.collector,
    this.createdAt,
    this.status,
    this.approveAt,
    this.requestItems,
    this.grandTotalAmount,
    this.amountWallet,
    this.amountCash
  });

  factory HostOrder.fromRawJson(String str) => HostOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostOrder.fromJson(Map<String, dynamic> json) => HostOrder(
    id: json["id"] == null ? null : json["id"],
    requestTime: json["request_time"] == null ? null : json["request_time"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    host: json["host"] == null ? null : Host.fromJson(json["host"]),
    collector: json["collector"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    status: json["status"] == null ? null : json["status"],
    approveAt: json["approve_at"],
    requestItems: json["request_items"] == null ? null : List<RequestItem>.from(json["request_items"].map((x) => RequestItem.fromJson(x))),
    grandTotalAmount: json["grand_total_amount"] == null ? null : json["grand_total_amount"],
    amountWallet: json["total_amount_payment_via_wallet"] == null ? null : json["total_amount_payment_via_wallet"],
    amountCash: json["total_amount_payment_via_cash"] == null ? null : json["total_amount_payment_via_cash"],

  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "request_time": requestTime == null ? null : requestTime,
    "address": address == null ? null : address.toJson(),
    "host": host == null ? null : host.toJson(),
    "collector": collector,
    "created_at": createdAt == null ? null : createdAt,
    "status": status == null ? null : status,
    "approve_at": approveAt,
    "request_items": requestItems == null ? null : List<dynamic>.from(requestItems.map((x) => x.toJson())),
    "grand_total_amount": grandTotalAmount == null ? null : grandTotalAmount,
    "total_amount_payment_via_wallet": amountWallet == null ? null : amountWallet,
    "total_amount_payment_via_cash": amountCash == null ? null : amountCash,
  };
}

class Address {
  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  dynamic radius;

  Address({
    this.id,
    this.lLat,
    this.lLong,
    this.addressTitle,
    this.addressDescription,
    this.localName,
    this.district,
    this.city,
    this.radius,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] == null ? null : json["id"],
    lLat: json["l_lat"] == null ? null : json["l_lat"].toDouble(),
    lLong: json["l_long"] == null ? null : json["l_long"].toDouble(),
    addressTitle: json["address_title"] == null ? null : json["address_title"],
    addressDescription: json["address_description"] == null ? null : json["address_description"],
    localName: json["local_name"] == null ? null : json["local_name"],
    district: json["district"] == null ? null : json["district"],
    city: json["city"] == null ? null : json["city"],
    radius: json["radius"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "l_lat": lLat == null ? null : lLat,
    "l_long": lLong == null ? null : lLong,
    "address_title": addressTitle == null ? null : addressTitle,
    "address_description": addressDescription == null ? null : addressDescription,
    "local_name": localName == null ? null : localName,
    "district": district == null ? null : district,
    "city": city == null ? null : city,
    "radius": radius,
  };
}

class Host {
  int id;
  String name;
  String phone;
  String email;
  List<AcceptScrap> acceptScraps;
  List<Address> addresses;

  Host({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.acceptScraps,
    this.addresses,
  });

  factory Host.fromRawJson(String str) => Host.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    acceptScraps: json["accept_scraps"] == null ? null : List<AcceptScrap>.from(json["accept_scraps"].map((x) => AcceptScrap.fromJson(x))),
    addresses: json["addresses"] == null ? null : List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "phone": phone == null ? null : phone,
    "email": email == null ? null : email,
    "accept_scraps": acceptScraps == null ? null : List<dynamic>.from(acceptScraps.map((x) => x.toJson())),
    "addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class AcceptScrap {
  int id;
  String hostPrice;
  Scrap scrap;

  AcceptScrap({
    this.id,
    this.hostPrice,
    this.scrap,
  });

  factory AcceptScrap.fromRawJson(String str) => AcceptScrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AcceptScrap.fromJson(Map<String, dynamic> json) => AcceptScrap(
    id: json["id"] == null ? null : json["id"],
    hostPrice: json["host_price"] == null ? null : json["host_price"],
    scrap: json["scrap"] == null ? null : Scrap.fromJson(json["scrap"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "host_price": hostPrice == null ? null : hostPrice,
    "scrap": scrap == null ? null : scrap.toJson(),
  };
}

class Scrap {
  int id;
  String name;
  String collectorPrice;
  String description;
  String image;
  int status;

  Scrap({
    this.id,
    this.name,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  factory Scrap.fromRawJson(String str) => Scrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Scrap.fromJson(Map<String, dynamic> json) => Scrap(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    collectorPrice: json["collector_price"] == null ? null : json["collector_price"],
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "collector_price": collectorPrice == null ? null : collectorPrice,
    "description": description == null ? null : description,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
  };
}