import 'dart:async';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';
import 'package:vecaprovider/config/app_config.dart' as config;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' show DateFormat;
import 'package:vecaprovider/src/widgets/custom_dialog.dart';
import 'package:vecaprovider/src/widgets/custom_dialog2.dart';
import 'package:vecaprovider/src/widgets/momo_notification.dart';

import 'const.dart';

class UIHelper {
  PermissionStatus permissionstatus;
  var _hasShowDialog = false;
  var hasShowPopUp = false;

  void showToast(BuildContext context, String message) {
    ToastUtils.showCustomToast(context, message);
  }

  Future<void> requestPermission() async {
    permissionstatus = await Permission.location.status;
    if (permissionstatus == PermissionStatus.granted) {
    } else if (permissionstatus == PermissionStatus.denied ||
        permissionstatus == PermissionStatus.undetermined ||
        permissionstatus == PermissionStatus.restricted) {
      await Permission.location.request();
    }
  }

  Future<BitmapDescriptor> createBitmapDescriptor(
      BuildContext context, String assetImage, int width) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(context, assetImage, width);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(
      BuildContext context, String path, int width) async {
    ByteData data = await DefaultAssetBundle.of(context).load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static double bearingBetweenLocations(
      double lats1, double lons1, double lats2, double lons2) {
    print("Location" +
        lats1.toString() +
        lons1.toString() +
        lats2.toString() +
        lons2.toString());

    double PI = 3.14159;
    double lat1 = lats1 * PI / 180;
    double long1 = lons1 * PI / 180;
    double lat2 = lats2 * PI / 180;
    double long2 = lons2 * PI / 180;
    double dLon = (long2 - long1);
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double brng = radianToDeg(atan2(y, x));

    brng = (brng + 360) % 360;

    return brng;
  }

  handleCommonState(BuildContext context, BaseState state) async {
    if (state is LoadingState) {
      state.isLoading ? showLoading(context: context) : hideLoading();
    }

    if (state is ErrorState) {
      hideLoading();
      await Future.delayed(Duration(milliseconds: 300));
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: state.error,
          buttonText: localizedText(context, 'close'),
          image: Image.asset(
            'img/icon_warning.png',
            color: Colors.white,
          ),
          context: context,
          onPress: () {
            hasShowPopUp = false;
            Navigator.of(context).pop();
          });
    }
  }

  handleUnauthenticatedState(BuildContext context, BaseState state) async {
    if (state is UnauthenticatedState) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, "unauthenticated"),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset('img/icon_warning.png', color: Colors.white),
          context: context,
          onPress: () {
            hasShowPopUp = false;
            Prefs.clearAll();
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNamed.SIGN_IN, (Route<dynamic> route) => false);
          });
    }
  }

  ProgressDialog pr;
  Completer<void> refreshCompleter;

  intUI() {
    refreshCompleter = Completer<void>();
  }

  showLoading({@required BuildContext context}) {
    if (pr == null) {
      pr = ProgressDialog(context);
    }
    pr.show();
  }

  hideLoading() {
    if (pr == null) {
      return;
    }
    pr.hide();
  }

  String localizedText(BuildContext context, String key, {dynamic args}) {
    return AppLocalizations.of(context).tr(key, args: args);
  }

  BoxDecoration getBoxDecoration(BuildContext context) {
    return new BoxDecoration(
      color: Colors.white,
      border:
          Border.all(color: Colors.black12, width: 0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).primaryColor,
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 1)
      ],
    );
  }

  LinearGradient getLinearGradient() {
    return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          config.Colors().mainDarkColor(1),
          config.Colors().mainColor(1),
        ]);
  }

  LinearGradient getLinearGradientButton() {
    return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFdce260),
          Color(0xFF39b64a),
        ]);
  }

  hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String skipHtml(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  String formatTime(int dateint) {
    String date = DateFormat('dd/MM/yyyy - HH:mm')
        .format(new DateTime.fromMillisecondsSinceEpoch(dateint));
    return date;
  }

  showCustomDialog(
      {BuildContext context,
      String title,
      String description,
      String buttonText,
      Image image,
      Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: localizedText(context, title),
              description: localizedText(context, description),
              buttonText: buttonText,
              image: image,
              onPress: onPress,
            ));
  }

  loadingPager(BuildContext context, double heightScreen) {
    return Container(
        height: heightScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ));
  }

  showCustomDialog2(
      {BuildContext context,
      String title,
      String description,
      String buttonText,
      String buttonClose,
      Image image,
      Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialog2(
              title: localizedText(context, title),
              description: localizedText(context, description),
              buttonText: buttonText,
              buttonClose: buttonClose,
              image: image,
              onPress: onPress,
              onClose: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              },
            ));
  }

  momoNotificaiton({BuildContext context, Image image, Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => MomoNotification(
              image: image,
              onClose: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              },
            ));
  }
}
