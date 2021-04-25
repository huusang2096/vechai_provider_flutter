import 'package:flutter/material.dart';
import 'package:vecaprovider/src/models/product.dart';

class Store {
  String id = UniqueKey().toString();
  String name;
  String image;
  String description;
  List<Product> productsList;

}
