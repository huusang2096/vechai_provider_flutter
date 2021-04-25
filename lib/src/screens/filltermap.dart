import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/place_address_bloc.dart';
import 'package:vecaprovider/src/bloc/place_address_event.dart';
import 'package:vecaprovider/src/bloc/place_address_state.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AddressModel.dart';
import 'package:vecaprovider/src/models/AddressRequest.dart';
import 'package:vecaprovider/src/models/place_model.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/widgets/MarqueeWidget.dart';

class FilterMapWidget extends StatefulWidget {
  final Function(AddressModel) onSelectAddress;
  AddressModel addressModel;
  FilterMapWidget({this.onSelectAddress, this.addressModel});

  static provider(
      BuildContext context, onSelectAddress, AddressModel addressModel) {
    return BlocProvider(
      create: (context) => PlaceAddressBloc(),
      child: FilterMapWidget(
          onSelectAddress: onSelectAddress, addressModel: addressModel),
    );
  }

  @override
  _FilterMapWidgetState createState() => _FilterMapWidgetState();
}

class _FilterMapWidgetState extends State<FilterMapWidget> with UIHelper {
  final String screenName = "HOME";
  PlaceAddressBloc _bloc;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Repository repository = Repository.instance;

  // Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;

  // int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;

  Position currentLocation;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  double lat, lng;

  String district = "";
  String city = "";
  var serviceStatus;

  Set<Circle> circles;
  double radiusSelect = 5000;
  bool isLocation = false;
  bool isMove = true;
  final _addressLocaNameController = TextEditingController();
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PlaceAddressBloc>(context);
    if (widget.addressModel != null) {
      radiusSelect = widget.addressModel.radius;
    }
    _getLocationAndUpdate();
  }

  void setDistane() {
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: radiusSelect,
          center: LatLng(lat, lng),
          fillColor: Theme.of(context).accentColor.withOpacity(0.6),
          strokeWidth: 0)
    ]);
  }

  _getLocationAndUpdate() async {
    if (await Geolocator().isLocationServiceEnabled()) {
      _initCurrentLocation();
    } else {
      _checkLocationService();
    }
  }

  Future<bool> _checkLocationService() async {
    serviceStatus = await Geolocator().isLocationServiceEnabled();
    if (!serviceStatus) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, 'no_address_exists'),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset('img/icon_warning.png', color: Colors.white),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            serviceStatus = await Geolocator().isLocationServiceEnabled();
            if (serviceStatus) {
              Navigator.of(context).pop();
              _initCurrentLocation();
            } else {
              AppSettings.openLocationSettings();
            }
          });
      return false;
    }
    return true;
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    if (widget.addressModel != null) {
      currentLocation = new Position(
          latitude: widget.addressModel.lLat,
          longitude: widget.addressModel.lLong);
      setState(() {
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
        district = widget.addressModel.district;
        _addressLocaNameController.text = widget.addressModel.localName;
        city = widget.addressModel.city;
        radiusSelect = widget.addressModel.radius as double;
        setDistane();
      });
    } else {
      currentLocation = await _locationService.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
          currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          district = pos.subAdministrativeArea;
          city = pos.administrativeArea;
          _addressLocaNameController.text = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
          lat = currentLocation.latitude;
          lng = currentLocation.longitude;
          setDistane();
        });
      }
    }
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  /// Get current location
  Future<void> _initCurrentLocationButton() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
        currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        district = pos.subAdministrativeArea ?? "";
        city = pos.administrativeArea ?? "";
        _addressLocaNameController.text = pos.name +
            ', ' +
            pos.thoroughfare +
            ', ' +
            pos.subAdministrativeArea +
            ', ' +
            pos.administrativeArea +
            ', ' +
            pos.country;
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
        setDistane();
      });
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
          zoom: 12.5,
        ),
      ),
    );
  }

  _searchAddress() {
    var callBack = (place) {
      Place placeHouse = place;
      getLocationName(
          placeHouse.lat, placeHouse.lng, placeHouse.formattedAddress);
    };
    Navigator.of(context)
        .pushNamed(RouteNamed.SEARCH_ADDRESS, arguments: callBack);
  }

  void cameraUpdate(double lat, double lng) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12.5,
    )));
    Future.delayed(Duration(milliseconds: 2000), () async {
      isMove = true;
    });
  }

  /// Get current location name
  void getLocationName(double lat, double lng, String name) async {
    isMove = false;
    if (lat != null && lng != null) {
      setState(() {
        _addressLocaNameController.text = name;
        this.lat = lat;
        this.lng = lng;
        setDistane();
      });
      cameraUpdate(lat, lng);
    }
  }

  void locationMove(double lat, double lng) async {
    if (lat != null && lng != null && isMove) {
      List<Placemark> placemarks =
          await Geolocator()?.placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          district = pos.subAdministrativeArea ?? "";
          city = pos.administrativeArea ?? "";
          _addressLocaNameController.text = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
          this.lat = lat;
          this.lng = lng;
          setDistane();
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    LatLng position = LatLng(
        currentLocation != null ? currentLocation?.latitude : 10.767843,
        currentLocation != null ? currentLocation?.longitude : 106.674354);
    /* MarkerId markerId = MarkerId(_markerIdVal());
    
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
    );
    setState(() {
      _markers[markerId] = marker;
    }); */
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 12.5,
          ),
        ),
      );
    });
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
    return BlocListener<PlaceAddressBloc, BaseState>(
        listener: (context, state) {
      handleCommonState(context, state);
      if (state is UploadAddressSuccessState) {
        widget.onSelectAddress(state.addressModel);
        Navigator.of(context).pop();
      }
    }, child:
            BlocBuilder<PlaceAddressBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            SizedBox(
              //height: MediaQuery.of(context).size.height - 180,
              child: GoogleMap(
                // markers: Set<Marker>.of(_markers.values),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                circles: circles,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation != null
                          ? currentLocation?.latitude
                          : 10.767843,
                      currentLocation != null
                          ? currentLocation?.longitude
                          : 106.674354),
                  zoom: 12.5,
                ),
                onCameraMove: (CameraPosition position) {},
                onCameraIdle: _onCameraIdle,
              ),
            ),
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
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        _searchAddress();
                                      },
                                      child: TextFormField(
                                          enabled: _obscureText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          keyboardType: TextInputType.text,
                                          controller:
                                              _addressLocaNameController,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              border: InputBorder.none))),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText ? Icons.done : Icons.edit,
                                    color: Theme.of(context).accentColor,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 35.0,
                left: 30,
                right: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                    ),
                    InkWell(
                      onTap: () {
                        AddressRequest addressModel = new AddressRequest();
                        addressModel.lLat = lat;
                        addressModel.lLong = lng;
                        addressModel.localName =
                            _addressLocaNameController.text;
                        addressModel.city = city;
                        addressModel.district = district;
                        addressModel.addressTitle = "Name";
                        addressModel.addressDescription = "ChiTiet";
                        addressModel.radius = 0;
                        _bloc.add(UploadAddress(addressModel));
                      },
                      child: Container(
                        width: 150.0,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: getLinearGradient(),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 15)
                          ],
                        ),
                        child: Center(
                          child: Text(
                            localizedText(context, 'finish'),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _initCurrentLocationButton();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        child: Icon(
                          Icons.my_location,
                          size: 30.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    )
                  ],
                )),
            Center(
              child: Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            )
          ],
        ),
      );
    }));
  }

  _onCameraIdle() async {
    final size = MediaQuery.of(context).size;
    final deviceRatio = MediaQuery.of(context).devicePixelRatio;
    final isAndroid = Platform.isAndroid;
    final width = isAndroid ? size.width * deviceRatio : size.width;
    final height = isAndroid ? size.height * deviceRatio : size.height;
    final screenCoordinate = ScreenCoordinate(x: width ~/ 2, y: height ~/ 2.0);
    final centerLatLng = await _mapController.getLatLng(screenCoordinate);
    locationMove(centerLatLng.latitude, centerLatLng.longitude);
  }
}
