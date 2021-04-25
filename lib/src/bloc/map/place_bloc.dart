import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/config/config.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/models/place_model.dart';


class PlaceBloc with ChangeNotifier {
  StreamController<Place> locationController =
      StreamController<Place>.broadcast();
  Place locationSelect;
  Place formLocation;
  List<Place> listPlace;
  Repository repository = Repository.instance;
  List<Place> listPlaceSearch;

  PlaceBloc({this.repository});

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.apiKey}&language=${Config.language}&region=${Config.region}&query=" +
            Uri.encodeQueryComponent(query);
    print(url);
    Response response = await Dio().get(url);
    print(Place.parseLocationList(response.data));
    listPlace = Place.parseLocationList(response.data);
    notifyListeners();
    return listPlace;
  }


  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(Place location) async {
    notifyListeners();
    locationSelect = location;
    return locationSelect;
  }

  Future<void> getCurrentLocation(Place location) async {
    notifyListeners();
    formLocation = location;
    return formLocation;
  }


  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}
