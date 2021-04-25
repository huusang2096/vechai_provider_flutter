// To parse this JSON data, do
//
//     final ordersReposne = ordersReposneFromJson(jsonString);

import 'dart:convert';
import 'package:vecaprovider/src/models/basemodel.dart';

import 'Shop.dart';

enum HistoryState {
  confirmed_history,
  finished_history,
}

class OrdersReposne extends BaseResponse {
  bool success;
  String message;
  List<HistoryModel> data;

  OrdersReposne({
    this.success,
    this.message,
    this.data,
  });

  factory OrdersReposne.fromRawJson(String str) =>
      OrdersReposne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersReposne.fromJson(Map<String, dynamic> json) => OrdersReposne(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<HistoryModel>.from(
                json["data"].map((x) => HistoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };

  @override
  bool hasData() {
    return data != null;
  }
}

class HistoryModel {
  int id;
  String orderNumber;
  int customerId;
  dynamic ipAddress;
  dynamic email;
  bool disputed;
  String orderStatus;
  String paymentStatus;
  PaymentMethod paymentMethod;
  dynamic messageToCustomer;
  String buyerNote;
  dynamic shipTo;
  dynamic shippingZoneId;
  dynamic shippingRateId;
  String shippingAddress;
  String billingAddress;
  String shippingWeight;
  dynamic packagingId;
  dynamic couponId;
  String total;
  String shipping;
  String packaging;
  String handling;
  String taxes;
  dynamic discount;
  String grandTotal;
  String taxrate;
  String orderDate;
  dynamic shippingDate;
  dynamic deliveryDate;
  dynamic trackingId;
  dynamic trackingUrl;
  Shop shop;
  List<Item> items;

  HistoryModel({
    this.id,
    this.orderNumber,
    this.customerId,
    this.ipAddress,
    this.email,
    this.disputed,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.messageToCustomer,
    this.buyerNote,
    this.shipTo,
    this.shippingZoneId,
    this.shippingRateId,
    this.shippingAddress,
    this.billingAddress,
    this.shippingWeight,
    this.packagingId,
    this.couponId,
    this.total,
    this.shipping,
    this.packaging,
    this.handling,
    this.taxes,
    this.discount,
    this.grandTotal,
    this.taxrate,
    this.orderDate,
    this.shippingDate,
    this.deliveryDate,
    this.trackingId,
    this.trackingUrl,
    this.shop,
    this.items,
  });

  factory HistoryModel.fromRawJson(String str) =>
      HistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json["id"] == null ? "" : json["id"],
        orderNumber: json["order_number"] == null ? null : json["order_number"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        ipAddress: json["ip_address"],
        email: json["email"],
        disputed: json["disputed"] == null ? null : json["disputed"],
        orderStatus: json["order_status"] == null ? null : json["order_status"],
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
        paymentMethod: json["payment_method"] == null
            ? null
            : PaymentMethod.fromJson(json["payment_method"]),
        messageToCustomer: json["message_to_customer"],
        buyerNote: json["buyer_note"] == null ? null : json["buyer_note"],
        shipTo: json["ship_to"] == null ? null : json["ship_to"],
        shippingZoneId:
            json["shipping_zone_id"] == null ? null : json["shipping_zone_id"],
        shippingRateId: json["shipping_rate_id"],
        shippingAddress:
            json["shipping_address"] == null ? null : json["shipping_address"],
        billingAddress:
            json["billing_address"] == null ? null : json["billing_address"],
        shippingWeight:
            json["shipping_weight"] == null ? null : json["shipping_weight"],
        packagingId: json["packaging_id"],
        couponId: json["coupon_id"],
        total: json["total"] == null ? null : json["total"],
        shipping: json["shipping"] == null ? null : json["shipping"],
        packaging: json["packaging"],
        handling: json["handling"]== null ? "0" : json["handling"],
        taxes: json["taxes"] == null ? "0" : json["taxes"],
        discount: json["discount"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        taxrate: json["taxrate"] == null ? null : json["taxrate"],
        orderDate: json["order_date"] == null ? null : json["order_date"],
        shippingDate: json["shipping_date"],
        deliveryDate: json["delivery_date"],
        trackingId: json["tracking_id"],
        trackingUrl: json["tracking_url"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order_number": orderNumber == null ? null : orderNumber,
        "customer_id": customerId == null ? null : customerId,
        "ip_address": ipAddress,
        "email": email,
        "disputed": disputed == null ? null : disputed,
        "order_status": orderStatus == null ? null : orderStatus,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        "payment_method": paymentMethod == null ? null : paymentMethod.toJson(),
        "message_to_customer": messageToCustomer,
        "buyer_note": buyerNote == null ? null : buyerNote,
        "ship_to": shipTo == null ? null : shipTo,
        "shipping_zone_id": shippingZoneId == null ? null : shippingZoneId,
        "shipping_rate_id": shippingRateId,
        "shipping_address": shippingAddress == null ? null : shippingAddress,
        "billing_address": billingAddress == null ? null : billingAddress,
        "shipping_weight": shippingWeight == null ? null : shippingWeight,
        "packaging_id": packagingId,
        "coupon_id": couponId,
        "total": total == null ? null : total,
        "shipping": shipping == null ? null : shipping,
        "packaging": packaging,
        "handling": handling == null? "0": handling,
        "taxes": taxes == null ? "0" : taxes,
        "discount": discount,
        "grand_total": grandTotal == null ? null : grandTotal,
        "taxrate": taxrate == null ? null : taxrate,
        "order_date": orderDate == null ? null : orderDate,
        "shipping_date": shippingDate,
        "delivery_date": deliveryDate,
        "tracking_id": trackingId,
        "tracking_url": trackingUrl,
        "shop": shop == null ? null : shop.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  int id;
  String slug;
  Pivot pivot;

  Item({
    this.id,
    this.slug,
    this.pivot,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"] == null ? null : json["id"],
        slug: json["slug"] == null ? null : json["slug"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "slug": slug == null ? null : slug,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class Pivot {
  String itemDescription;
  int quantity;
  String unitPrice;
  String total;
  String image;

  Pivot({
    this.itemDescription,
    this.quantity,
    this.unitPrice,
    this.total,
    this.image,
  });

  factory Pivot.fromRawJson(String str) => Pivot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        itemDescription:
            json["item_description"] == null ? null : json["item_description"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        unitPrice: json["unit_price"] == null ? null : json["unit_price"],
        total: json["total"] == null ? null : json["total"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "item_description": itemDescription == null ? null : itemDescription,
        "quantity": quantity == null ? null : quantity,
        "unit_price": unitPrice == null ? null : unitPrice,
        "total": total == null ? null : total,
        "image": image == null ? null : image,
      };
}

class PaymentMethod {
  int id;
  int order;
  String type;
  String code;
  String name;
  dynamic image;

  PaymentMethod({
    this.id,
    this.order,
    this.type,
    this.code,
    this.name,
    this.image,
  });

  factory PaymentMethod.fromRawJson(String str) =>
      PaymentMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"] == null ? null : json["id"],
        order: json["order"] == null ? null : json["order"],
        type: json["type"] == null ? null : json["type"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order": order == null ? null : order,
        "type": type == null ? null : type,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "image": image,
      };
}
