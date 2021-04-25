import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/create_order_scrap/create_order_scrap_bloc.dart';
import 'package:vecaprovider/src/bloc/create_order_scrap/create_order_scrap_event.dart';
import 'package:vecaprovider/src/bloc/create_order_scrap/create_order_scrap_state.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/models/create_order_online_response.dart';
import 'package:vecaprovider/src/widgets/line_dash.dart';

class CreateOrderScrapScreen extends StatefulWidget {
  final List<ScrapModel> listScrapModel;

  CreateOrderScrapScreen({this.listScrapModel});
  static provider(BuildContext context, List<ScrapModel> listScrapModel) {
    return BlocProvider(
      create: (context) => CreateOrderScrapBloc(),
      child: CreateOrderScrapScreen(listScrapModel: listScrapModel),
    );
  }

  @override
  _CreateOrderScrapScreenState createState() => _CreateOrderScrapScreenState();
}

class _CreateOrderScrapScreenState extends State<CreateOrderScrapScreen>
    with UIHelper {
  CreateOrderScrapBloc _bloc;
  OrderOnline hostOrder;
  bool isCreateOrderSuccess = false;

  @override
  void initState() {
    _bloc = BlocProvider.of(context);

    _bloc.add(SendOrderRequest(listScrapModel: widget.listScrapModel));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderScrapBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if (state is CreateOrderOnlineSuccessState) {
          hostOrder = state.response.data;
        }
        if (state is ConfirmCreateOrderSuccessState) {
          Navigator.of(context).pop(state.isCreateOrderSuccess);
        }
      },
      child: BlocBuilder<CreateOrderScrapBloc, BaseState>(
        builder: (context, state) {
          var data = EasyLocalizationProvider.of(context).data;
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
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
                  localizedText(context, 'censorship'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        elevation: 14.0,
                        shadowColor: Color(0x802196F3),
                        borderRadius: BorderRadius.circular(12.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: hostOrder != null
                              ? Column(
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 10.0,
                                          left: 10.0),
                                      title: Text(
                                          localizedText(context, 'subtotal'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.left),
                                      trailing: Text(
                                        hostOrder.grandTotalAmount.toString() +
                                            "đ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    LineDash(color: Colors.grey),
                                    SizedBox(height: 10),
                                    ListTile(
                                      title: Text(
                                        localizedText(context, 'order_detail'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      primary: false,
                                      children: <Widget>[
                                        ListTile(
                                          dense: true,
                                          leading: Icon(
                                            Icons.art_track,
                                            size: 25,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 0.0,
                                              right: 10.0,
                                              left: 10.0),
                                          title: Text(
                                              localizedText(
                                                  context, 'id_order'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              textAlign: TextAlign.left),
                                          trailing: Text(
                                            hostOrder.id.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                        ListTile(
                                          dense: true,
                                          leading: Icon(
                                            Icons.date_range,
                                            size: 25,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 0.0,
                                              right: 10.0,
                                              left: 10.0),
                                          title: Text(
                                              localizedText(
                                                  context, 'date_create_order'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              textAlign: TextAlign.left),
                                          trailing: Text(
                                            formatTime(hostOrder.createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final item = hostOrder.requestItems
                                            .elementAt(index);
                                        return ItemProduct(
                                          item: item,
                                        );
                                      },
                                      primary: true,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: hostOrder.requestItems.length,
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              : _buildShimmer(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        //Confirm create order
                        _bloc.add(ConfirmCreateOrder(
                            hostOderId:
                                hostOrder.requestItems[0].buyRequestId));
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: getLinearGradient(),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(localizedText(context, 'confirm'),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(TextStyle(color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          LineDash(color: Colors.grey),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ItemProduct extends StatelessWidget {
  final RequestItem item;

  ItemProduct({this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 55,
          height: 55,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(item?.scrap?.image ??
                      'https://cdn2.iconfinder.com/data/icons/image-1/64/Image-12-512.png'),
                  fit: BoxFit.contain),
            ),
          )),
      title: Text(item?.scrap?.name ?? '',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.left),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.weight.toString().replaceAll(".", ","),
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: Text(
        item.totalAmount.toString() + "đ",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
