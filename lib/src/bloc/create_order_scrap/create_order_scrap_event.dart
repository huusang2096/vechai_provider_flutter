import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';

class ConfirmCreateOrderScrap extends BaseEvent {}

class GetOrderByHost extends BaseEvent {
  int idOrder;
  GetOrderByHost({this.idOrder});
}

class SendOrderRequest extends BaseEvent {
  final List<ScrapModel> listScrapModel;
  SendOrderRequest({this.listScrapModel});
}

class ConfirmCreateOrder extends BaseEvent {
  final int hostOderId;

  ConfirmCreateOrder({this.hostOderId});
}
