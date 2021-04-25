import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/bloc/map/place_bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/place_model.dart';

class SelectMapWidget extends StatefulWidget {
  final PlaceBloc placeBloc;

  SelectMapWidget({this.placeBloc});

  @override
  _SelectMapWidgetState createState() => _SelectMapWidgetState();
}

class _SelectMapWidgetState extends State<SelectMapWidget> with UIHelper {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Repository repository = Repository.instance;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  String _placemark = '';
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  PersistentBottomSheetController _controller;

  Position currentLocation;
  Position _lastKnownPosition;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  final _nameTextController = TextEditingController();
  bool isLocation = false;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
        currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.name +
            ', ' +
            pos.thoroughfare +
            ', ' +
            pos.subAdministrativeArea +
            ', ' +
            pos.administrativeArea +
            ', ' +
            pos.country;
      });
      widget?.placeBloc?.getCurrentLocation(Place(
          name: _placemark,
          formattedAddress: _placemark,
          lat: currentLocation?.latitude,
          lng: currentLocation?.longitude));
    }
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  void cameraUpdate(Place place){
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(place.lat, place.lng),
      zoom: 14.4746,
    )));
  }

  /// Get current location name
  void getLocationName(double lat, double lng) async {
    if (lat != null && lng != null) {
      List<Placemark> placemarks =
          await Geolocator()?.placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        _placemark = pos.name +
            ', ' +
            pos.thoroughfare +
            ', ' +
            pos.subAdministrativeArea +
            ', ' +
            pos.administrativeArea +
            ', ' +
            pos.country;
        print(_placemark);
        widget?.placeBloc?.getCurrentLocation(
            Place(name: _placemark, formattedAddress: _placemark, lat: lat, lng: lng));
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(
        currentLocation != null ? currentLocation?.latitude : 0.0,
        currentLocation != null ? currentLocation?.longitude : 0.0);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
    );
    setState(() {
      _markers[markerId] = marker;
    });
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName) {
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SizedBox(
            //height: MediaQuery.of(context).size.height - 180,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation != null
                        ? currentLocation?.latitude
                        : _lastKnownPosition?.latitude ?? 0.0,
                    currentLocation != null
                        ? currentLocation?.longitude
                        : _lastKnownPosition?.longitude ?? 0.0),
                zoom: 12.0,
              ),
              onCameraMove: (CameraPosition position) {
                if (_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers[markerId];
                  Marker updatedMarker = marker?.copyWith(
                    positionParam: position?.target,
                  );
                  setState(() {
                    _markers[markerId] = updatedMarker;
                    _position = position;
                  });
                }
              },
              onCameraIdle: () => getLocationName(
                  _position?.target?.latitude != null
                      ? _position?.target?.latitude
                      : currentLocation?.latitude,
                  _position?.target?.longitude != null
                      ? _position?.target?.longitude
                      : currentLocation?.longitude),
            ),
          ),
          Positioned(
            top: 35,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(flex: 0,child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),),
                Flexible(flex: 1,child: InkWell(
                  onTap: () {
                    var callBack = (place) {
                      cameraUpdate(place);
                    };
                    Navigator.of(context).pushNamed(RouteNamed.SEARCH_ADDRESS, arguments: callBack );
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Icon(
                              Icons.search,
                              color: Theme.of(context).accentColor
                          ),
                          SizedBox(width: 10),
                          Text(
                            localizedText(context, 'search'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),),
                Flexible(flex: 0,child: InkWell(
                onTap: () {
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).accentColor,
                  ),
                )))
              ],
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Container(
                height: 150.0,
                child: Material(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new TextField(
                            style: TextStyle(color: Theme.of(context).textSelectionColor),
                            keyboardType: TextInputType.text,
                            controller: _nameTextController,
                            decoration: new InputDecoration(
                              errorText: null,
                              hintText: localizedText(context, 'name_address'),
                              hintStyle: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.location_city,
                                size: 25,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.my_location,
                                size: 25,
                                color: Theme.of(context).accentColor),
                            title: Text(
                              widget?.placeBloc?.formLocation?.name ?? "",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          /* Padding(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: MaterialButton(
                onPressed: (){
                  widget.yourAddress.name = _nameTextController.text;
                  widget.ontap(widget.yourAddress);
                },
                child: Text(
                  localizedText(context, 'done'),
                  style: Theme.of(context).textTheme.title.merge(
                    TextStyle(
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                color: Theme.of(context).accentColor,
                elevation: 0,
                minWidth: 350,
                height: 55,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),*/
                        ],
                      )
                  ),
                )),
          ),
          Positioned(
              bottom: 200,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _initCurrentLocation();
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 20.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
