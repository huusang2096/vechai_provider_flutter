// To parse this JSON data, do
//
//     final facebookProfile = facebookProfileFromJson(jsonString);

import 'dart:convert';

class FacebookProfile {
  String name;
  String firstName;
  String lastName;
  String email;
  String id;

  FacebookProfile({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  factory FacebookProfile.fromRawJson(String str) => FacebookProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FacebookProfile.fromJson(Map<String, dynamic> json) => FacebookProfile(
    name: json["name"] == null ? null : json["name"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "id": id == null ? null : id,
  };
}
