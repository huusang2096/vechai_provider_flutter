// To parse this JSON data, do
//
//     final createOrderOnlineResponse = createOrderOnlineResponseFromJson(jsonString);

import 'dart:convert';

class CreateOrderOnlineResponse {
  CreateOrderOnlineResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  OrderOnline data;

  factory CreateOrderOnlineResponse.fromRawJson(String str) =>
      CreateOrderOnlineResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderOnlineResponse.fromJson(Map<String, dynamic> json) =>
      CreateOrderOnlineResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : OrderOnline.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class OrderOnline {
  OrderOnline({
    this.id,
    this.address,
    this.host,
    this.collector,
    this.createdAt,
    this.status,
    this.approveAt,
    this.requestItems,
    this.grandTotalAmount,
    this.totalAmountPaymentViaWallet,
    this.totalAmountPaymentViaCash,
    this.isDirect,
  });

  int id;
  Address address;
  Host host;
  String collector;
  int createdAt;
  String status;
  dynamic approveAt;
  List<RequestItem> requestItems;
  String grandTotalAmount;
  String totalAmountPaymentViaWallet;
  String totalAmountPaymentViaCash;
  bool isDirect;

  factory OrderOnline.fromRawJson(String str) =>
      OrderOnline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderOnline.fromJson(Map<String, dynamic> json) => OrderOnline(
        id: json["id"] == null ? null : json["id"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        host: json["host"] == null ? null : Host.fromJson(json["host"]),
        collector: json["collector"] == null ? null : json["collector"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        status: json["status"] == null ? null : json["status"],
        approveAt: json["approve_at"],
        requestItems: json["request_items"] == null
            ? null
            : List<RequestItem>.from(
                json["request_items"].map((x) => RequestItem.fromJson(x))),
        grandTotalAmount: json["grand_total_amount"] == null
            ? null
            : json["grand_total_amount"],
        totalAmountPaymentViaWallet:
            json["total_amount_payment_via_wallet"] == null
                ? null
                : json["total_amount_payment_via_wallet"],
        totalAmountPaymentViaCash: json["total_amount_payment_via_cash"] == null
            ? null
            : json["total_amount_payment_via_cash"],
        isDirect: json["is_direct"] == null ? null : json["is_direct"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "address": address == null ? null : address.toJson(),
        "host": host == null ? null : host.toJson(),
        "collector": collector == null ? null : collector,
        "created_at": createdAt == null ? null : createdAt,
        "status": status == null ? null : status,
        "approve_at": approveAt,
        "request_items": requestItems == null
            ? null
            : List<dynamic>.from(requestItems.map((x) => x.toJson())),
        "grand_total_amount":
            grandTotalAmount == null ? null : grandTotalAmount,
        "total_amount_payment_via_wallet": totalAmountPaymentViaWallet == null
            ? null
            : totalAmountPaymentViaWallet,
        "total_amount_payment_via_cash": totalAmountPaymentViaCash == null
            ? null
            : totalAmountPaymentViaCash,
        "is_direct": isDirect == null ? null : isDirect,
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

class RequestItem {
  RequestItem({
    this.id,
    this.buyRequestId,
    this.scrap,
    this.weight,
    this.price,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int buyRequestId;
  Scrap scrap;
  int weight;
  String price;
  String totalAmount;
  int createdAt;
  int updatedAt;

  factory RequestItem.fromRawJson(String str) =>
      RequestItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestItem.fromJson(Map<String, dynamic> json) => RequestItem(
        id: json["id"] == null ? null : json["id"],
        buyRequestId:
            json["buy_request_id"] == null ? null : json["buy_request_id"],
        scrap: json["scrap"] == null ? null : Scrap.fromJson(json["scrap"]),
        weight: json["weight"] == null ? null : json["weight"],
        price: json["price"] == null ? null : json["price"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "buy_request_id": buyRequestId == null ? null : buyRequestId,
        "scrap": scrap == null ? null : scrap.toJson(),
        "weight": weight == null ? null : weight,
        "price": price == null ? null : price,
        "total_amount": totalAmount == null ? null : totalAmount,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
