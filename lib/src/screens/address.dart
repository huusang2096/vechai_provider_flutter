import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/address/address_bloc.dart';
import 'package:vecaprovider/src/bloc/address/address_event.dart';
import 'package:vecaprovider/src/bloc/address/address_state.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';

class AddressWidget extends StatefulWidget {
  @override
  State<AddressWidget> createState() {
    // TODO: implement createState
    return _AddressWidgetState();
  }
}

class _AddressWidgetState extends State<AddressWidget> with UIHelper {
  ProgressDialog pr;
  AddressBloc _bloc;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<AddressBloc>(context); // TODO: implement initState
    intUI();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onRefresh() {
      _bloc.add(FetchAddressList());
      return refreshCompleter.future;
    }

    return BlocListener<AddressBloc, AddressState>(listener: (context, state) {
      if (state is FetchDataLoading) {
        pr.show();
      }

      if (state is FetchDataDismiss) {
        pr.dismiss();
      }

      if (state is DeleteFailure) {
        showToast(context, state.error);
      }

      if (state is LoadedAddress) {
        refreshCompleter?.complete();
        intUI();
      }
    }, child: BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return Scaffold(
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
            title: Text(
              localizedText(context, 'address'),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
            actions: <Widget>[
              new IconButton(
                icon:
                    new Icon(Icons.add, color: Theme.of(context).primaryColor),
                onPressed: () {
                    Navigator.of(context).pushNamed(RouteNamed.ADDRESS_MAP);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            child: _buildBody(state),
            onRefresh: _onRefresh,
          ));
    }));
  }

  _buildBody(state) {
    /* if (state is LoadAddressFailure) {
      return Center(
        child: Text(state.error),
      );
    }
    if (state is LoadedAddress) {
      if (state.items.isEmpty) {
        return Center(
          child: Text(localizedText(context, 'assress_is_empty')),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile(
                    item: (state is LoadedAddress) ? state.items[index] : [],
                    onDeletePressed: (id) {
                      BlocProvider.of<AddressBloc>(context)
                          .add(DeleteAddress(id: id));
                    },
                    onSelectAddress: (Address) {
                      Navigator.of(context)
                          .pushNamed(RouteNamed.ADDRESS_DETAIL,
                              arguments: (state is LoadedAddress)
                                  ? state.items[index]
                                  : null)
                          .then((val) => BlocProvider.of<AddressBloc>(context)
                              .add(FetchAddressList()));
                    },
                  );
                },
                itemCount: (state is LoadedAddress) ? state.items.length : 0,
              )),
            ],
          ),
        );
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );*/
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ItemTile(
                item: null,
                onDeletePressed: (id) {
                  BlocProvider.of<AddressBloc>(context)
                      .add(DeleteAddress(id: id));
                },
                onSelectAddress: (Address) {},
              );
            },
            itemCount: 3,
          )),
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Address item;
  final Function(int) onDeletePressed;
  final Function(Address) onSelectAddress;

  const ItemTile(
      {Key key,
      @required this.item,
      @required this.onDeletePressed,
      @required this.onSelectAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => onSelectAddress(item),
          leading: Image.asset('img/icon_address.png',
              color: Theme.of(context).accentColor, width: 40),
          title: Text("My Home",
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Toky, Vietnam, Thanh pho HoChiMinh, Quan 12, Phuong Trung MyTAy",
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left)
            ],
          ),
          trailing: false
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDeletePressed(item.id),
                ),
        ),
        SizedBox(height: 5),
        Divider(color: Colors.black12)
      ],
    );
  }
}
