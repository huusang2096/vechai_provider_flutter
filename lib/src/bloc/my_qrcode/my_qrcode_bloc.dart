import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/my_qrcode/my_qrcode_event.dart';
import 'package:vecaprovider/src/bloc/my_qrcode/my_qrcode_state.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';

class MyQRCodeBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialMyQRCodeState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is CaptureAndShareProviderID) {
      RenderRepaintBoundary boundary =
          event.scaffoldKey.currentContext.findRenderObject();
      final image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qrcode.png').create();
      await file.writeAsBytes(pngBytes);
      await Share.shareFiles(['${tempDir.path}/qrcode.png'], text: 'QrCode');
    }
  }
}
