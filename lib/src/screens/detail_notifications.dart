import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/notification.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNotifications extends StatefulWidget {

  final NotificationData notification;

  DetailNotifications({this.notification});

  @override
  _DetailNotificationsState createState() => _DetailNotificationsState();

}

class _DetailNotificationsState extends State<DetailNotifications>
    with UIHelper {
  WebViewController _webViewController;

  loadAsset(url) async {
    _webViewController.loadUrl(Uri.dataFromString(url,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon, color: Theme
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
          localizedText(context, 'notification'),
          style: Theme
              .of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme
              .of(context)
              .primaryColor)),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(flex: 0, child: Container(
              margin: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Text(
                  widget.notification.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                  maxLines: null,
                ),
                Text(
                  widget.notification.time,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2,
                  maxLines: null,
                ),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Divider(color: Colors.black12)
                ),],),
            ),),
            Flexible(flex: 1, child:  Container(
              child: WebView(
                initialUrl: '',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                  loadAsset(widget.notification.body);
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://')) {
                    _launchURL(request.url);
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
              ),
            ))
          ],
        ),
      ),
    );

  }
}
