import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/my_qrcode/my_qrcode_bloc.dart';
import 'package:vecaprovider/src/bloc/my_qrcode/my_qrcode_event.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class MyQRCodeScreen extends StatefulWidget {
  const MyQRCodeScreen({Key key, this.providerID}) : super(key: key);

  @override
  _MyQRCodeScreenState createState() => _MyQRCodeScreenState();

  final String providerID;

  static provider(BuildContext context, String providerID) {
    return BlocProvider<MyQRCodeBloc>(
      create: (_) => MyQRCodeBloc(),
      child: MyQRCodeScreen(
        providerID: providerID,
      ),
    );
  }
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> with UIHelper {
  MyQRCodeBloc _bloc;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final double width = 220.0;
  final double height = 220.0;

  @override
  void initState() {
    _bloc = BlocProvider.of<MyQRCodeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    return BlocListener<MyQRCodeBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        // if(state is MyQRCodeState){}
      },
      child: BlocBuilder<MyQRCodeBloc, BaseState>(
        builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
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
                  localizedText(context, 'my_qrcode'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _bloc.add(
                          CaptureAndShareProviderID(scaffoldKey: _scaffoldKey));
                    },
                  )
                ],
              ),
              body: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.providerID.isEmpty
                          ? _shimmerQR()
                          : Container(
                              // color: Colors.white,
                              child: RepaintBoundary(
                                key: _scaffoldKey,
                                child: QrImage(
                                  gapless: false,
                                  backgroundColor: Colors.white,
                                  data: widget.providerID.toString(),
                                  version: QrVersions.auto,
                                  size: width,
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      Text(localizedText(context, 'give_or_share_qrcode')),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shimmerQR() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(height: height, width: width, color: Colors.white),
    );
  }
}
