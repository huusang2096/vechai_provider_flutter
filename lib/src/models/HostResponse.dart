// To parse this JSON data, do
//
//     final hostResponse = hostResponseFromJson(jsonString);

import 'dart:convert';

import 'package:vecaprovider/src/models/AddressModel.dart';

class HostResponse {
  HostResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<HostModel> data;

  factory HostResponse.fromRawJson(String str) => HostResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostResponse.fromJson(Map<String, dynamic> json) => HostResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<HostModel>.from(json["data"].map((x) => HostModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HostModel {
  HostModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.distance,
    this.addresses,
    this.acceptScraps,
  });

  int id;
  String name;
  String phone;
  String email;
  double distance;
  List<AddressModel> addresses;
  List<AcceptScrap> acceptScraps;

  factory HostModel.fromRawJson(String str) => HostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostModel.fromJson(Map<String, dynamic> json) => HostModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    addresses: json["addresses"] == null ? null : List<AddressModel>.from(json["addresses"].map((x) => AddressModel.fromJson(x))),
    acceptScraps: json["accept_scraps"] == null ? null : List<AcceptScrap>.from(json["accept_scraps"].map((x) => AcceptScrap.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "phone": phone == null ? null : phone,
    "email": email == null ? null : email,
    "distance": distance == null ? null : distance,
    "addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
    "accept_scraps": acceptScraps == null ? null : List<dynamic>.from(acceptScraps.map((x) => x.toJson())),
  };
}

class AcceptScrap {
  AcceptScrap({
    this.id,
    this.hostPrice,
    this.scrap,
  });

  int id;
  String hostPrice;
  Scrap scrap;

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
  Scrap({
    this.id,
    this.name,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  int id;
  String name;
  String collectorPrice;
  String description;
  String image;
  int status;

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

