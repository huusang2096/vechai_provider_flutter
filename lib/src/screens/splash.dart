import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> with UIHelper{
  var serviceStatus;


  startTime() async {
    requestPermission()?.then((_) async {
      var _duration = new Duration(seconds: 2);
      return new Timer(_duration, navigationPage);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocationAndUpdate();
  }

  _getLocationAndUpdate() async {
    if (await Geolocator().isLocationServiceEnabled()) {
      startTime();
    } else {
      _checkLocationService();
    }
  }

  Future<bool> _checkLocationService() async {
    serviceStatus = await Geolocator().isLocationServiceEnabled();
    if (!serviceStatus) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, 'location_is_disabled'),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset(
              'img/icon_warning.png'),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            serviceStatus = await Geolocator().isLocationServiceEnabled();
            if (serviceStatus) {
              Navigator.of(context).pop();
              startTime();
            } else {
              AppSettings.openLocationSettings();
            }
          });
      return false;
    }
    return true;
  }

  void navigationPage() async {
    if(await Prefs.getToken() != ""){
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/Tabs", (Route<dynamic> route) => false,
            arguments: 2);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNamed.SIGN_IN);
    }
}

  @override
  Widget build(BuildContext context) {
    // Screen Util
    return new Scaffold(
      body:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('img/splash_screen.png'),
                fit: BoxFit.cover)),
      ),);
  }
}
