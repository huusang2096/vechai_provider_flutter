import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';

class QrcodeWidget extends StatefulWidget {

  int id;

  @override
  _QrcodeWidgetState createState() => _QrcodeWidgetState();

  QrcodeWidget(this.id);

}

class _QrcodeWidgetState extends State<QrcodeWidget> with UIHelper {
  ProgressDialog pr;
  GlobalKey globalKey = new GlobalKey();

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.close,
              color: Theme
                  .of(context)
                  .primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace:   Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: Text(
          localizedText(context, 'finish_censorship'),
          style: Theme
              .of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme
              .of(context)
              .primaryColor))),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.share,
                color: Theme
                    .of(context)
                    .primaryColor),
            onPressed: () {
              _captureAndSharePng();
            },
          )
        ],
      ),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            gradient: getLinearGradient(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color:
                  Theme.of(context).hintColor.withOpacity(0.15),
                  offset: Offset(0, 3),
                  blurRadius: 15)
            ],
          ),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushReplacementNamed(
                  '/Tabs', arguments: 2);
            },
            child:Center(
              child: Text(
                localizedText(context, 'done'),
                style: Theme.of(context).textTheme.headline4.merge(
                  TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                child: Column(children: <Widget>[
                  ListTile(
                    title: Text(
                      localizedText(context, 'orders_code'),
                      textAlign: TextAlign.left,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4,
                    ),
                    subtitle: Text(
                      localizedText(context,
                          'check_orders_code'),
                      textAlign: TextAlign.left,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,
                    ),
                  ),
                ],)
            ),
            Container(
                height: 10,
                color: Theme
                    .of(context)
                    .focusColor
                    .withOpacity(0.15)),
            SizedBox(height: 10),
            Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: widget.id.toString(),
                  size: 300,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
