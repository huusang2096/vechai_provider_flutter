import 'package:qrcode/qrcode.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class TransferScanQRcode extends BaseEvent {}

class ChangeIsPause extends BaseEvent {
  final bool isPause;
  ChangeIsPause({this.isPause});
}

class ValidationData extends BaseEvent {
  final String data;
  ValidationData({this.data});
}

class HandleDataQrcode extends BaseEvent {
  final String data;
  final bool isPopAndReturnData;
  final QRCaptureController captureController;
  HandleDataQrcode(
      {this.data, this.isPopAndReturnData, this.captureController});
}
