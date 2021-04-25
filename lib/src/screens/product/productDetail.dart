import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/Images.dart';
import 'package:vecaprovider/src/models/ScrapDetailResponse.dart';

class ProductDetailWidget extends StatefulWidget {

  ScrapDetailModel scrapDetailModel;

  ProductDetailWidget(this.scrapDetailModel);

  @override
  _ProductDetailWidgetState createState() =>
      _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  TrackingScrollController _trackingScrollController;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  double _opacityAppBar = 0;

  List<Images> images = [];

  @override
  void initState() {
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
    _trackingScrollController = TrackingScrollController();
    _tabController.addListener(_handleTabSelection);
    images.add(new Images(widget.scrapDetailModel.image));
    super.initState();

    _trackingScrollController.addListener(() {
      double currentScroll = _trackingScrollController.position.pixels;
      if (currentScroll <= 0) {
        setState(() {
          _opacityAppBar = 0;
        });
      } else {
        setState(() {
          _opacityAppBar = 1;
        });
      }
    });
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon,
              color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace:   Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          localizedText(context, 'order_detail'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme.of(context).primaryColor))),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  localizedText(context, 'skip'),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Theme.of(context).accentColor)),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          controller: _trackingScrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        children: <Widget>[
                          // Carousel
                          Container(
                              height: 300,
                              color: Colors.white,
                              child: _buildHeader()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(5.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        child: _buildTitle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(5.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        child: _buildInfo(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(5.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: _buildInfoTech(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(5.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        width: double.infinity,
                        child: _buildComments(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )
          )),);
  }

  Widget _buildHeader() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            width: double.infinity,
            child: CarouselSlider(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              viewportFraction: 0.8,
              onPageChanged: (pageIndex) {},
              enlargeCenterPage: true,
              items: images.map((Images images) {
                return Builder(
                  builder: (context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                            imageUrl: images.path)
                    );
                  },
                );
              }).toList(),
            )
        ),
        IgnorePointer(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0),
                      Theme.of(context).scaffoldBackgroundColor
                    ],
                    stops: [
                      0,
                      0.4,
                      0.6,
                      1
                    ])),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.scrapDetailModel.name,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 25),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.local_shipping,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(width: 5),
            Text(
              widget.scrapDetailModel.collectorPrice,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          leading: Icon(
            UiIcons.file_2,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            localizedText(context, 'product_description'),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Container(
          child: Html(
            data: widget.scrapDetailModel.description,
          ),
        )
      ],
    );
  }


  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, left: 16, bottom: 16, right: 16),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.chat_1,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              localizedText(context, "product_reviews"),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTech() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          leading: Icon(
            UiIcons.file_2,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            localizedText(context, 'detail'),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Container(
          child: Html(
            data: widget.scrapDetailModel.description,
          ),
        )
      ],
    );
  }
}
