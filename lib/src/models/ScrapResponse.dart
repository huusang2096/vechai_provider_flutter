// To parse this JSON data, do
//
//     final scrapResponse = scrapResponseFromJson(jsonString);

import 'dart:convert';

class ScrapResponse {
  bool success;
  String message;
  List<ScrapModel> data;

  ScrapResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ScrapResponse.fromRawJson(String str) =>
      ScrapResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapResponse.fromJson(Map<String, dynamic> json) => ScrapResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ScrapModel>.from(
                json["data"].map((x) => ScrapModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ScrapModel {
  int id;
  String name;
  String hostPrice;
  bool hostAcceptScrap;
  String collectorPrice;
  String description;
  String image;
  int status;
  bool isSelect;
  double weight;
  double sumPrice;

  ScrapModel(
      {this.id,
      this.name,
      this.hostPrice,
      this.hostAcceptScrap,
      this.collectorPrice,
      this.description,
      this.image,
      this.status,
      this.isSelect,
      this.weight,
      this.sumPrice});

  ScrapModel copyWith(
          {int id,
          String name,
          String collectorPrice,
          String description,
          String image,
          int status,
          bool isSelect,
          double weight,
          double sumPrice}) =>
      ScrapModel(
          id: id ?? this.id,
          name: name ?? this.name,
          hostPrice: hostPrice ?? this.hostPrice,
          hostAcceptScrap: hostAcceptScrap ?? this.hostAcceptScrap,
          collectorPrice: collectorPrice ?? this.collectorPrice,
          description: description ?? this.description,
          image: image ?? this.image,
          status: status ?? this.status,
          isSelect: isSelect ?? this.isSelect,
          weight: weight ?? this.weight,
          sumPrice: sumPrice ?? this.sumPrice);

  factory ScrapModel.fromRawJson(String str) =>
      ScrapModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapModel.fromJson(Map<String, dynamic> json) => ScrapModel(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      hostPrice: json["host_price"] == null ? null : json["host_price"],
      hostAcceptScrap:
          json["host_accept_scrap"] == null ? null : json["host_accept_scrap"],
      collectorPrice:
          json["collector_price"] == null ? null : json["collector_price"],
      description: json["description"] == null ? null : json["description"],
      image: json["image"] == null ? null : json["image"],
      status: json["status"] == null ? null : json["status"],
      isSelect: false,
      weight: 0,
      sumPrice: 0);

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
