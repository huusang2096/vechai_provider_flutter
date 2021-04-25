import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/ProductHostGridItemWidget.dart';
import 'package:vecaprovider/config/app_config.dart' as config;

class ShopWidget extends StatefulWidget {
  HostModel hostModel;
  bool isHost;

  @override
  _ShopState createState() => _ShopState();

  ShopWidget(this.hostModel, this.isHost);
}

class _ShopState extends State<ShopWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Position currentLocation;

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.hostModel.email,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> fetchLocation() async {
    currentLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  _openGoogleMap(String dlat, String dLong, String slat, String sLong) {
    String url =
        "https://www.google.com/maps/dir/?api=1&origin=$dlat,$dLong&destination=$slat,$sLong&mode=driving";
    _launchURL(url);
  }

  _callPhone(String number) async {
    if (await canLaunch("tel:" + number)) {
      await launch("tel:" + number);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).accentColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: widget.isHost ? 140 : 180,
            elevation: 0,
            bottom: PreferredSize(
              // Add this code
              preferredSize:
                  Size.fromHeight(widget.isHost ? 140 : 180), // Add this code
              child: Text(''), // Add this code
            ),
            flexibleSpace: _buidHeader(),
          ),
          _buildBody()
        ]),
      ),
    );
  }

  _userAvatar() {
    return AssetImage('img/cover.png');
  }

  _buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              title: Text(
                localizedText(context, 'list_scraps'),
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.headline4,
              )),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget.hostModel.acceptScraps.length,
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                AcceptScrap product =
                    widget.hostModel.acceptScraps.elementAt(index);
                return ProductHostGridItemWidget(
                  product: product,
                  heroTag: product?.scrap?.name ?? '' + index.toString(),
                );
              },
            )),
      ]),
    );
  }

  _buidHeader() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 50, right: 50, top: 80),
          width: double.infinity,
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(300),
                            child: CircleAvatar(backgroundImage: _userAvatar()),
                          )),
                      SizedBox(height: 5),
                      Text(
                          widget.hostModel == null ? "" : widget.hostModel.name,
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                widget.hostModel != null &&
                        widget.hostModel.addresses.length != 0 &&
                        widget.isHost == false
                    ? InkWell(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                gradient: getLinearGradient(),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'img/map.png',
                                    width: 20,
                                    color: Colors.white,
                                  )),
                            ),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                      widget.hostModel.addresses[0].localName,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .merge(TextStyle(
                                              color: config.Colors()
                                                  .accentDarkColor(1)))),
                                ))
                          ],
                        ),
                        onTap: () {
                          _openGoogleMap(
                              currentLocation.latitude.toString(),
                              currentLocation.longitude.toString(),
                              widget.hostModel.addresses[0].lLat.toString(),
                              widget.hostModel.addresses[0].lLong.toString());
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
