// To parse this JSON data, do
//
//     final privacyPolicyResonse = privacyPolicyResonseFromJson(jsonString);

import 'dart:convert';

class PrivacyPolicyResonse {
  PrivacyPolicyResonse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory PrivacyPolicyResonse.fromRawJson(String str) => PrivacyPolicyResonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivacyPolicyResonse.fromJson(Map<String, dynamic> json) => PrivacyPolicyResonse(
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
    this.id,
    this.title,
    this.slug,
    this.content,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String slug;
  String content;
  dynamic image;
  int createdAt;
  int updatedAt;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    slug: json["slug"] == null ? null : json["slug"],
    content: json["content"] == null ? null : json["content"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "slug": slug == null ? null : slug,
    "content": content == null ? null : content,
    "image": image,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}
