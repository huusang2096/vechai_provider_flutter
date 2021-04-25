import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/widgets/google_map_helper.dart';

class DirectionScreen extends StatefulWidget {
  OrderModel order;

  @override
  _DirectionScreenState createState() => _DirectionScreenState();

  DirectionScreen({Key key, this.order}) : super(key: key);
}

class _DirectionScreenState extends State<DirectionScreen> with UIHelper {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  BitmapDescriptor markerIcon;

  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  Polyline polyline;
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  bool checkPlatform = Platform.isIOS;
  String distance, duration;
  LatLng positionDriver;
  bool isComplete = false;
  List<Route> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  PanelController panelController = new PanelController();
  By requestBy;
  By acceptedBy;
  Position currentLocation;
  final Geolocator _locationService = Geolocator();
  MarkerId markerIdFrom;
  MarkerId markerIdTo;
  BitmapDescriptor iconDriverISO,
      iconDriverAndroid,
      iconHomeISO,
      iconHomeAndroid;
  StreamSubscription _getPositionSubscription;

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    getIconApp();
    requestBy = widget.order.requestBy;
    acceptedBy = widget.order.acceptedBy;
    fetchLocation();
  }

  @override
  void dispose() {
    if (_getPositionSubscription != null) {
      _getPositionSubscription.cancel();
    }
    super.dispose();
  }

  Future<void> fetchLocation() async {
    currentLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    getPolyline(LatLng(currentLocation.latitude, currentLocation.longitude),
        LatLng(requestBy.currentAddress.lLat, requestBy.currentAddress.lLong));

    _getPositionSubscription = _locationService
        .getPositionStream(LocationOptions(accuracy: LocationAccuracy.best))
        .listen((position) {
      double bearing = UIHelper.bearingBetweenLocations(
          currentLocation?.latitude ?? 0,
          currentLocation?.longitude ?? 0,
          position.latitude,
          position.longitude);
      print("bearing : " + bearing.toString());
      currentLocation = position;
      addMarkerCar(currentLocation, bearing);
    });
  }

  getIconApp() async {
    iconDriverISO =
        await createBitmapDescriptor(context, "img/car_delivery.png", 60);
    iconDriverAndroid =
        await createBitmapDescriptor(context, "img/car_delivery.png", 60);

    iconHomeISO =
        await createBitmapDescriptor(context, "img/trashHouse.png", 100);
    iconHomeAndroid =
        await createBitmapDescriptor(context, "img/trashHouse.png", 100);
  }

  addMakers() async {
    checkPlatform ? print('ios') : print("adnroid");
    markerIdFrom = MarkerId("from_address");
    markerIdTo = MarkerId("to_address");

    final Marker marker = GMapViewHelper.createMaker2(
        markerIdVal: "from_address",
        icon: checkPlatform ? iconDriverISO : iconDriverAndroid,
        lat: currentLocation.latitude,
        lng: currentLocation.longitude,
        bearing: 0.0);

    final Marker markerTo = GMapViewHelper.createMaker2(
        markerIdVal: "to_address",
        icon: checkPlatform ? iconHomeISO : iconHomeAndroid,
        lat: requestBy.currentAddress.lLat,
        lng: requestBy.currentAddress.lLong,
        bearing: 0.0);

    setState(() {
      markers[markerIdFrom] = marker;
      markers[markerIdTo] = markerTo;
    });
  }

  addMarkerCar(Position location, double bearing) {
    if (mounted)
      setState(() {
        markers[markerIdFrom] = GMapViewHelper.createMaker2(
            markerIdVal: "carLocation",
            icon: checkPlatform ? iconDriverISO : iconDriverAndroid,
            lat: location.latitude,
            lng: location.longitude,
            bearing: bearing);
      });
  }

  getPolyline(LatLng formLocation, LatLng toLocation) async {
    showLoading(context: context);
    final directionsResponse = await Repository.instance.getDirections(
        fromLat: formLocation.latitude,
        fromLng: formLocation.longitude,
        toLat: toLocation.latitude,
        toLng: toLocation.longitude);
    final routes = directionsResponse.routes ?? [];
    hideLoading();
    addMakers();
    if (routes.length > 0) {
      final router = routes.first.overviewPolyline.points;
      final polylineId = "polyline_id_closet";
      polyline = GMapViewHelper.createPolyline(
          polylineIdVal: polylineId,
          router: router,
          formLocation: LatLng(formLocation.latitude, formLocation.longitude),
          toLocation: LatLng(toLocation.latitude, toLocation.longitude));
      polyLines.clear();
      polyLines[polyline.polylineId] = polyline;
      _gMapViewHelper.cameraMove(
          fromLocation: formLocation,
          toLocation: toLocation,
          mapController: _mapController);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openGoogleMap(String dlat, String dLong, String slat, String sLong) {
    String url =
        "https://www.google.com/maps/dir/?api=1&origin= $dlat,$dLong&destination=$slat,$sLong&mode=driving";
    _launchURL(url);
  }

  _callPhone(String number) async {
    if (await canLaunch("tel:" + number)) {
      await launch("tel:" + number);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SizedBox(
              child: GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(10.774180, 106.647619),
              zoom: 13,
            ),
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polyLines.values),
          )),
          Positioned(
            top: 35,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 0,
                  child: InkWell(
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    flex: 0,
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                      ),
                    )),
                Flexible(
                  flex: 0,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteNamed.UPDATE_ORDER,
                            arguments: widget.order.id);
                      },
                      child: Container(
                        height: 50.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          gradient: getLinearGradient(),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: Center(
                          child: Text(
                            localizedText(context, 'drop_off'),
                            style: Theme.of(context).textTheme.headline4.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      )),
                ),
                Flexible(
                  flex: 0,
                  child: InkWell(
                    onTap: () {
                      _openGoogleMap(
                          currentLocation.latitude.toString(),
                          currentLocation.longitude.toString(),
                          requestBy.currentAddress.lLat.toString(),
                          requestBy.currentAddress.lLong.toString());
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
                        Icons.map,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
