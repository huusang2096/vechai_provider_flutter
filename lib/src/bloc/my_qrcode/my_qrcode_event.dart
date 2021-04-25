import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class MyQRCodeHome extends BaseEvent {}

class CaptureAndShareProviderID extends BaseEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;
  CaptureAndShareProviderID({this.scaffoldKey});
}
