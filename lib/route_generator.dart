import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/address/address_bloc.dart';
import 'package:vecaprovider/src/bloc/address/address_event.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/changePassword/bloc.dart';
import 'package:vecaprovider/src/bloc/createOrder/bloc.dart';
import 'package:vecaprovider/src/bloc/map/map_bloc.dart';
import 'package:vecaprovider/src/bloc/map/place_bloc.dart';
import 'package:vecaprovider/src/bloc/signin/bloc.dart';
import 'package:vecaprovider/src/bloc/tabs/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/RequestPhoneNumberResponse.dart';
import 'package:vecaprovider/src/models/ScrapDetailResponse.dart';
import 'package:vecaprovider/src/models/notification.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/screens/address.dart';
import 'package:vecaprovider/src/screens/create_order.dart';
import 'package:vecaprovider/src/screens/create_order_scrap.dart';
import 'package:vecaprovider/src/screens/detail_notifications.dart';
import 'package:vecaprovider/src/screens/direction_screen.dart';
import 'package:vecaprovider/src/screens/filltermap.dart';
import 'package:vecaprovider/src/screens/my_qrcode/my_qrcode.dart';
import 'package:vecaprovider/src/screens/newPassword.dart';
import 'package:vecaprovider/src/screens/changePassword.dart';
import 'package:vecaprovider/src/screens/contact.dart';
import 'package:vecaprovider/src/screens/help.dart';
import 'package:vecaprovider/src/screens/languages.dart';
import 'package:vecaprovider/src/screens/notification/notifications.dart';
import 'package:vecaprovider/src/screens/orderDetail/orderDetail.dart';
import 'package:vecaprovider/src/screens/orderDetail/orderHostDetail.dart';
import 'package:vecaprovider/src/screens/orderDetail/orderTrashDetail.dart';
import 'package:vecaprovider/src/screens/orderList/stores.dart';
import 'package:vecaprovider/src/screens/orders.dart';
import 'package:vecaprovider/src/screens/orderDetail/ordersConfrimDetail.dart';
import 'package:vecaprovider/src/screens/otp.dart';
import 'package:vecaprovider/src/screens/product/productDetail.dart';
import 'package:vecaprovider/src/screens/qrcode.dart';
import 'package:vecaprovider/src/screens/recharge/recharge_screen.dart';
import 'package:vecaprovider/src/screens/resetpassword.dart';
import 'package:vecaprovider/src/screens/review.dart';
import 'package:vecaprovider/src/screens/search_address_screen.dart';
import 'package:vecaprovider/src/screens/select_product.dart';
import 'package:vecaprovider/src/screens/selectmap.dart';
import 'package:vecaprovider/src/screens/shop.dart';
import 'package:vecaprovider/src/screens/signin.dart';
import 'package:vecaprovider/src/screens/splash.dart';
import 'package:vecaprovider/src/screens/tabs.dart';
import 'package:vecaprovider/src/screens/transfers/transfers_screen.dart';
import 'package:vecaprovider/src/screens/transfers_scan_qrcode/transfer_scan_qrcode_screen.dart';
import 'package:vecaprovider/src/screens/update_order.dart';
import 'package:vecaprovider/src/screens/withdraw/history_withdrawal/history_withdrawal_screen.dart';
import 'package:vecaprovider/src/screens/withdraw/rule_withdrawal/rule_withdrawal_screen.dart';
import 'package:vecaprovider/src/screens/withdraw/withdraw_screen.dart';
import 'package:vecaprovider/src/widgets/BasePageRoute.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    final Repository repository = Repository.instance;

    switch (settings.name) {
      case RouteNamed.ROOT:
        return BasePageRoute(
            builder: (_) => SplashScreenWidget(),
            settings: RouteSettings(name: settings.name));
      case RouteNamed.SIGN_IN:
        return MaterialPageRoute(
            builder: (context) {
              return SignInWidget.provider(context);
            },
            settings: settings);
      case RouteNamed.FORGOT:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    SignInBloc(repository: repository),
                child: ResetPasswordWidget(),
              );
            },
            settings: settings);
      case RouteNamed.SELECT_PRODUCT:
        return MaterialPageRoute(
            builder: (context) => SelectProductWidget.provider(context),
            settings: settings);
      case RouteNamed.ADDRESS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                  create: (BuildContext context) =>
                      AddressBloc(repository: repository)
                        ..add(FetchAddressList()),
                  child: AddressWidget());
            },
            settings: settings);
      case RouteNamed.LANGUAGES:
        return MaterialPageRoute(
            builder: (_) => LanguagesWidget(), settings: settings);
      case RouteNamed.HELP:
        return MaterialPageRoute(
            builder: (_) => HelpWidget(), settings: settings);
      case RouteNamed.CONTACT:
        return MaterialPageRoute(
            builder: (context) => ContactWidget.provider(context),
            settings: settings);
      case RouteNamed.TABS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<TabsBloc>(
                create: (BuildContext context) => TabsBloc(),
                child: TabsWidget.provider(context, args),
              );
            },
            settings: settings);
      case RouteNamed.OTP:
        return MaterialPageRoute(
            builder: (context) {
              return OtpWidget.provider(
                  context, args as RequestPhoneNumberResponse);
            },
            settings: settings);
      case RouteNamed.CHANGE_PASS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    ChangePasswordBloc(repository: repository),
                child: ChangePasswordWidget(),
              );
            },
            settings: settings);
      case RouteNamed.SEARCH_ADDRESS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    MapBloc(repository: repository),
                child: SearchAddressScreen(onSelectAddress: args as Function),
              );
            },
            settings: settings);
      case RouteNamed.CREATE_ORDER:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    CreateOrderBloc(repository: repository),
                child: CreateOrderWidget(),
              );
            },
            settings: settings);
      case RouteNamed.NEW_PASS:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) {
              return NewPasswordWidget.provider(context, mapData["token"],
                  mapData["code"], mapData["phonenumber"]);
            },
            settings: settings);
      case RouteNamed.NOTIFICATIONS:
        return MaterialPageRoute(
            builder: (context) {
              return NotificationsWidget.provider(context);
            },
            settings: settings);
      case RouteNamed.PRODUCT:
        return MaterialPageRoute(
            builder: (context) {
              return ProductDetailWidget(args as ScrapDetailModel);
            },
            settings: settings);
      case RouteNamed.ADDRESS_MAP:
        return MaterialPageRoute(
            builder: (_) =>
                SelectMapWidget(placeBloc: PlaceBloc(repository: repository)),
            settings: settings);
      case RouteNamed.FILLTER_MAP:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) {
              return FilterMapWidget.provider(
                  context, mapData["funcition"], mapData["addressModel"]);
            },
            settings: settings);
      case RouteNamed.DETAIL_NOTIFICATIONS:
        return MaterialPageRoute(
            builder: (_) =>
                DetailNotifications(notification: args as NotificationData),
            settings: settings);

      case RouteNamed.ORDER_TRASH_DETAIL:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    CreateOrderBloc(repository: repository),
                child: OrderTrashDetailWidget(),
              );
            },
            settings: settings);
      case RouteNamed.UPDATE_ORDER:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) => ProductBloc(),
                child: UdpateOrderWidget(args as int),
              );
            },
            settings: settings);
      case RouteNamed.QR_CODE:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) => ProductBloc(),
                child: QrcodeWidget(args as int),
              );
            },
            settings: settings);
      case RouteNamed.SHOP_DETAIL:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                ShopWidget(mapData["HostModel"], mapData["isHost"]),
            settings: settings);
      case RouteNamed.DISTANCE:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    CreateOrderBloc(repository: repository),
                child: DirectionScreen(order: args as OrderModel),
              );
            },
            settings: settings);
      case RouteNamed.REVIEW:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    ChangePasswordBloc(repository: repository),
                child: ReviewWidget(),
              );
            },
            settings: settings);
      case RouteNamed.ORDER_CONFRIM_DETAIL:
        return MaterialPageRoute(
            builder: (context) =>
                OrdersConfrimDetailWidget(orderModel: args as OrderModel),
            settings: settings);
      case RouteNamed.ORDERS_DETAIL_CATEGORY:
        return MaterialPageRoute(
            builder: (context) =>
                OrderDetailCategoryWidget(orderModel: args as OrderModel),
            settings: settings);

      case RouteNamed.ORDERS_HOST_DETAIL_CATEGORY:
        return MaterialPageRoute(
            builder: (context) =>
                OrderHostDetailCategoryWidget(orderModel: args as OrderModel),
            settings: settings);
      case RouteNamed.STORES:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) => HostBloc(),
                child: StoreWidget(),
              );
            },
            settings: settings);
      case RouteNamed.HISTORY:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    CreateOrderBloc(repository: repository),
                child: StoreWidget(),
              );
            },
            settings: settings);
      case RouteNamed.WITHDRAW:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => WithdrawScreen.provider(
                context, mapData['withdrawal'], mapData['phonenumber']),
            settings: settings);

      case RouteNamed.HISTORY_WITHDRAWAL:
        return MaterialPageRoute(
            builder: (context) => HistoryWithdrawalScreen.provider(context),
            settings: settings);

      case RouteNamed.RULE_WITHDRAWAL:
        return MaterialPageRoute(
            builder: (_) => RuleWithdrawalScreen(), settings: settings);

      case RouteNamed.TRANSFERS:
        final map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => TransfersScreen.provider(
                context, map["user"], map["myAccount"]),
            settings: settings);
      case RouteNamed.RECHARGE:
        final map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) {
              return RechargeScreen.provider(context, map["myAccount"]);
            },
            settings: settings);
      case RouteNamed.TRANSFER_SCAN_QRCODE:
        final map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                ScanQRCodeScreen.provider(context, map["isPopAndReturnData"]),
            settings: settings);
      case RouteNamed.MY_QR_CODE:
        final map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                MyQRCodeScreen.provider(context, map["providerID"]),
            settings: settings);

      case RouteNamed.CREATE_ORDER_SCRAP:
        final map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                CreateOrderScrapScreen.provider(context, map['listScrapModel']),
            settings: settings);

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
