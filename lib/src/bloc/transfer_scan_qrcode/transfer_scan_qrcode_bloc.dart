import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/qrcode.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/transfer_scan_qrcode/transfer_scan_qrcode_event.dart';
import 'package:vecaprovider/src/bloc/transfer_scan_qrcode/transfer_scan_qrcode_state.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';

class TransferScanQRcodeBloc extends Bloc<BaseEvent, BaseState>
    with BlocHelper {
  @override
  BaseState get initialState => InitialTransferScanQRcodeState();

  bool isPause = false;
  bool isVal = false;
  QRCaptureController captureController;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ChangeIsPause) {
      isPause = event.isPause;
      yield ChangeIsPauseState(isPause: event.isPause);
    }
    if (event is ValidationData) {
      if (int.tryParse(event.data) == null) {
        yield ValidationDataSuccessState(isVal: false);
      }
      if (event.data.isEmpty) {
        yield ValidationDataSuccessState(isVal: false);
      }
      yield ValidationDataSuccessState(isVal: true);
    }
    if (event is HandleDataQrcode) {
      if (event.isPopAndReturnData) {
        final map = {'data': event.data};
        await Future.delayed(Duration(milliseconds: 300));
        yield PopAndPassDataState(map: map);
      }
    }
  }
}
