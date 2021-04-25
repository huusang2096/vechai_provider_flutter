// To parse this JSON data, do
//
//     final searchUserResponse = searchUserResponseFromJson(jsonString);

import 'dart:convert';

class SearchUserResponse {
  SearchUserResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<User> data;

  factory SearchUserResponse.fromRawJson(String str) =>
      SearchUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) =>
      SearchUserResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<User>.from(json["data"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.id,
    this.name,
    this.phoneCountryCode,
    this.phoneNumber,
    this.email,
    this.dob,
    this.sex,
    this.identificationNumber,
    this.description,
    this.active,
    this.avatar,
    this.currentAddress,
    this.apiToken,
    this.balance,
    this.host,
    this.isUpdatedPassword,
  });

  int id;
  String name;
  String phoneCountryCode;
  String phoneNumber;
  String email;
  String dob;
  String sex;
  String identificationNumber;
  String description;
  bool active;
  String avatar;
  Address currentAddress;
  String apiToken;
  String balance;
  List<Host> host;
  int isUpdatedPassword;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneCountryCode: json["phone_country_code"] == null
            ? null
            : json["phone_country_code"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        email: json["email"] == null ? null : json["email"],
        dob: json["dob"] == null ? null : json["dob"],
        sex: json["sex"] == null ? null : json["sex"],
        identificationNumber: json["identification_number"] == null
            ? null
            : json["identification_number"],
        description: json["description"] == null ? null : json["description"],
        active: json["active"] == null ? null : json["active"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        currentAddress: json["current_address"] == null
            ? null
            : Address.fromJson(json["current_address"]),
        apiToken: json["api_token"] == null ? null : json["api_token"],
        balance: json["balance"] == null ? null : json["balance"],
        host: json["host"] == null
            ? null
            : List<Host>.from(json["host"].map((x) => Host.fromJson(x))),
        isUpdatedPassword: json["is_updated_password"] == null
            ? null
            : json["is_updated_password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone_country_code":
            phoneCountryCode == null ? null : phoneCountryCode,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "email": email == null ? null : email,
        "dob": dob == null ? null : dob,
        "sex": sex == null ? null : sex,
        "identification_number":
            identificationNumber == null ? null : identificationNumber,
        "description": description == null ? null : description,
        "active": active == null ? null : active,
        "avatar": avatar == null ? null : avatar,
        "current_address":
            currentAddress == null ? null : currentAddress.toJson(),
        "api_token": apiToken == null ? null : apiToken,
        "balance": balance == null ? null : balance,
        "host": host == null
            ? null
            : List<dynamic>.from(host.map((x) => x.toJson())),
        "is_updated_password":
            isUpdatedPassword == null ? null : isUpdatedPassword,
      };
}

class Address {
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

  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  int radius;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        lLat: json["l_lat"] == null ? null : json["l_lat"].toDouble(),
        lLong: json["l_long"] == null ? null : json["l_long"].toDouble(),
        addressTitle:
            json["address_title"] == null ? null : json["address_title"],
        addressDescription: json["address_description"] == null
            ? null
            : json["address_description"],
        localName: json["local_name"] == null ? null : json["local_name"],
        district: json["district"] == null ? null : json["district"],
        city: json["city"] == null ? null : json["city"],
        radius: json["radius"] == null ? null : json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "l_lat": lLat == null ? null : lLat,
        "l_long": lLong == null ? null : lLong,
        "address_title": addressTitle == null ? null : addressTitle,
        "address_description":
            addressDescription == null ? null : addressDescription,
        "local_name": localName == null ? null : localName,
        "district": district == null ? null : district,
        "city": city == null ? null : city,
        "radius": radius == null ? null : radius,
      };
}

class Host {
  Host({
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
  int distance;
  List<Address> addresses;
  List<AcceptScrap> acceptScraps;

  factory Host.fromRawJson(String str) => Host.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        distance: json["distance"] == null ? null : json["distance"],
        addresses: json["addresses"] == null
            ? null
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x))),
        acceptScraps: json["accept_scraps"] == null
            ? null
            : List<AcceptScrap>.from(
                json["accept_scraps"].map((x) => AcceptScrap.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "distance": distance == null ? null : distance,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses.map((x) => x.toJson())),
        "accept_scraps": acceptScraps == null
            ? null
            : List<dynamic>.from(acceptScraps.map((x) => x.toJson())),
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

  factory AcceptScrap.fromRawJson(String str) =>
      AcceptScrap.fromJson(json.decode(str));

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
    this.hostPrice,
    this.hostAcceptScrap,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  int id;
  String name;
  String hostPrice;
  bool hostAcceptScrap;
  String collectorPrice;
  String description;
  String image;
  int status;

  factory Scrap.fromRawJson(String str) => Scrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Scrap.fromJson(Map<String, dynamic> json) => Scrap(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        hostPrice: json["host_price"] == null ? null : json["host_price"],
        hostAcceptScrap: json["host_accept_scrap"] == null
            ? null
            : json["host_accept_scrap"],
        collectorPrice:
            json["collector_price"] == null ? null : json["collector_price"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "host_price": hostPrice == null ? null : hostPrice,
        "host_accept_scrap": hostAcceptScrap == null ? null : hostAcceptScrap,
        "collector_price": collectorPrice == null ? null : collectorPrice,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "status": status == null ? null : status,
      };
}
