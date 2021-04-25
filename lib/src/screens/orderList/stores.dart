import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/widgets/OrderStoreWidget.dart';

class StoreWidget extends StatefulWidget {
  @override
  _StoreWidgetState createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> with UIHelper {
  String layout = 'list';
  List<HostModel> hostModels = [];
  HostBloc _bloc;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<HostBloc>(context);
    _bloc.add(HostSyncData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HostBloc, BaseState>(listener: (context, state) {
      if (state is HostsDataSuccessState) {
        hostModels = state.hosts;
      }
    }, child: BlocBuilder<HostBloc, BaseState>(builder: (context, state) {
      return Scaffold(
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
              localizedText(context, 'Store'),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
            actions: <Widget>[
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      localizedText(context, 'skip'),
                      style: Theme.of(context).textTheme.button.merge(
                          TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    title: Text(
                      localizedText(context, 'list_host'),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                hostModels.isNotEmpty
                    ? ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        primary: false,
                        itemCount: hostModels.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return OrderStoreItemWidget(
                            heroTag: hostModels[index].id.toString() +
                                index.toString(),
                            hostModel: hostModels[index],
                          );
                        },
                      )
                    : _buildShimmer(),
              ],
            ),
          ));
    }));
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        primary: false,
        itemCount: 5,
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final Size size = MediaQuery.of(context).size;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Material(
              elevation: 14.0,
              shadowColor: Color(0x802196F3),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 160,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}
