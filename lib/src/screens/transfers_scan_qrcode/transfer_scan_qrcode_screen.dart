import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/qrcode.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/transfer_scan_qrcode/transfer_scan_qrcode_bloc.dart';
import 'package:vecaprovider/src/bloc/transfer_scan_qrcode/transfer_scan_qrcode_event.dart';
import 'package:vecaprovider/src/bloc/transfer_scan_qrcode/transfer_scan_qrcode_state.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/screens/transfers_scan_qrcode/widget/button_scan_again.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class ScanQRCodeScreen extends StatefulWidget {
  final bool isPopAndReturnData;

  ScanQRCodeScreen({Key key, this.isPopAndReturnData}) : super(key: key);

  @override
  _ScanQRCodeScreenState createState() => _ScanQRCodeScreenState();

  static provider(BuildContext context, bool isPopAndReturnData) {
    return BlocProvider<TransferScanQRcodeBloc>(
        create: (context) => TransferScanQRcodeBloc(),
        child: ScanQRCodeScreen(isPopAndReturnData: isPopAndReturnData));
  }
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen>
    with UIHelper, TickerProviderStateMixin {
  TransferScanQRcodeBloc _bloc;
  QRCaptureController _captureController = QRCaptureController();
  bool isShowScanAgain = false;
  Animation<Alignment> _animation;
  AnimationController _animationController;
  String errorText = '';
  bool isVal = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TransferScanQRcodeBloc>(context);
    initCapture();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final Size size = MediaQuery.of(context).size;
    return BlocListener<TransferScanQRcodeBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if (state is ChangeIsPauseState) {
          isShowScanAgain = state.isPause;
        }
        if (state is ErrorTextState) {
          errorText = localizedText(context, state.errorText);
        }
        if (state is PopAndPassDataState) {
          Navigator.of(context).pop(state.map);
        }
        if (state is ValidationDataSuccessState) {
          isVal = state.isVal;
        }
      },
      child: BlocBuilder<TransferScanQRcodeBloc, BaseState>(
        builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              //key: _scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(UiIcons.return_icon,
                      color: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: getLinearGradient())),
                elevation: 0,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Text(
                  localizedText(context, 'scan_qrcode'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              body: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: ShapeQr(),
                          child: Container(
                            width: 230,
                            height: 230,
                          ),
                        ),
                        Container(
                          width: 220,
                          height: 220,
                          color: Colors.black,
                          child: QRCaptureView(
                            controller: _captureController,
                          ),
                        ),
                      ],
                    ),
                    isShowScanAgain
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width,
                                child: Text(
                                  errorText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ButtonScanAgain(
                                onPress: () {
                                  _bloc.add(ChangeIsPause(isPause: false));
                                  errorText = '';
                                  _captureController.resume();
                                },
                                size: size,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void initCapture() async {
    _captureController.onCapture((data) async {
      print('onCapture----$data');
      if (data != null) {
        _captureController.pause();
        await Future.delayed(Duration(milliseconds: 500));
        // isShowScanAgain = true;
        _bloc.add(ValidationData(data: data));
        await Future.delayed(Duration(milliseconds: 300));
        _captureAfter(data);
      }
    });
  }

  void _captureAfter(String data) async {
    if (isVal) {
      _bloc.add(HandleDataQrcode(
          data: data,
          isPopAndReturnData: widget.isPopAndReturnData,
          captureController: _captureController));
    } else {
      isShowScanAgain = true;
      errorText = localizedText(context, "we_cannot_recognize_this_qr_code");
    }
  }
}

class ShapeQr extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final defaultDash = 25.0;
    final height = size.height;
    final width = size.width;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, defaultDash);

    path.moveTo(0, 0);
    path.lineTo(defaultDash, 0);

    path.moveTo(0, height - defaultDash);
    path.lineTo(0, height);

    path.moveTo(0, height);
    path.lineTo(defaultDash, height);

    path.moveTo(width - defaultDash, height);
    path.lineTo(width, height);

    path.moveTo(width, height);
    path.lineTo(width, height - defaultDash);

    path.moveTo(width - defaultDash, 0);
    path.lineTo(width, 0);

    path.moveTo(width, 0);
    path.lineTo(width, defaultDash);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
