import 'package:flutter/material.dart';

class Product {
  String id = UniqueKey().toString();
  String name;
  String image;
  String description;
  String price1;
  String price2;
  bool isSelect;

  Product(this.name, this.image, this.price1, this.price2, this.isSelect);

}

class ProductsList {
  List<Product> _list;

  List<Product> get list => _list;

  ProductsList() {
    _list = [
      new Product('Giấy Cacton', 'img/pager.png', "1.000 VND/kg", "1.600 VND/kg", true),
      new Product('Giấy A4 ( Giấy VP) ', 'img/pager.png', "2.400 VND/kg", "3.000 VND/kg", false),
      new Product('Mũ', 'img/pager.png',  "4.000 VND/kg", "5.000 VND/kg", false),
      new Product('Nhựa', 'img/plastic.png',  "5.000 VND/kg", "6.000 VND/kg", false),
      new Product('Lon (nhôm)', 'img/meta.png',  "1.000 VND/kg", "1.000 VND/kg", false),
      new Product('Tôn', 'img/meta.png',  "3.000 VND/kg", "4.000 VND/kg", false),
      new Product('Sắt', 'img/meta.png',  "4.500 VND/kg", "5.200 VND/kg", false),
    ];
  }
}
