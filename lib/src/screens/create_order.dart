import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';

class CreateOrderWidget extends StatefulWidget {
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrderWidget> with UIHelper {


  final String screenName = "HOME";
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  BitmapDescriptor markerIcon;
  GoogleMapController _mapController;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  int _markerIdCounter = 0;

  Position currentLocation;
  Position _lastKnownPosition;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;


  @override
  void initState() {
    super.initState();
    _initCurrentLocation();

  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
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

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  _addAddress() {
      Navigator.of(context).pushNamed(RouteNamed.ADDRESS_MAP);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon,
              color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace:   Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          localizedText(context, 'create_order'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  localizedText(context, 'skip'),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Theme.of(context).accentColor)),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  offset: Offset(0, 3),
                  blurRadius: 10)
            ],
          ),
          padding: EdgeInsets.all(10.0),
          child: MaterialButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text(
              localizedText(context, 'order_trash'),
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  .merge(
                TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor),
              ),
            ),
            color: Theme
                .of(context)
                .accentColor,
            elevation: 0,
            minWidth: 250,
            height: 55,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.asset('img/icon_address.png',
                color: Theme.of(context).accentColor, width: 40),
            title: Text(
              localizedText(context, 'address_profile'),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ItemTile(
                item: null,
                onSelectAddress: (address) {},
              );
            },
            itemCount: 1,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 1,
                color: Theme
                    .of(context)
                    .accentColor,
              ),
              Text(
               localizedText(context, 'or_using_social'),
                //S.of(context).or_using_social,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,
              ),
              Container(
                width: 100,
                height: 1,
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ],),
          SizedBox(height: 10),
          ListTile(
            leading: Image.asset('img/map.png',
                color: Theme.of(context).accentColor, width: 25),
            title: Text(
              localizedText(context, 'address_location'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height/3,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
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
                      });
                    }
                  },
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 100,
                  right: 100,
                  child: GestureDetector(
                    onTap: _addAddress,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: MaterialButton(
                        onPressed: _addAddress,
                        child: Text(
                          localizedText(context, 'add_address'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6
                              .merge(
                            TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                          ),
                        ),
                        color: Theme
                            .of(context)
                            .accentColor,
                        elevation: 0,
                        minWidth: 50,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )),
            ],),
        ],
      )),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Address item;
  final Function(Address) onSelectAddress;

  const ItemTile({Key key, @required this.item, @required this.onSelectAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            onTap: () {
              onSelectAddress(item);
            },
            title: Text("My Home",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "Toky, Vietnam, Thanh pho HoChiMinh, Quan 12, Phuong Trung MyTAy",
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.left,
                    maxLines: null)
              ],
            ),
            trailing: Offstage(
                offstage: false,
                child: Icon(Icons.check, color: Theme.of(context).accentColor))),
        SizedBox(height: 5),
      ],
    );
  }
}
