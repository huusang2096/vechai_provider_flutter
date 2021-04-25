import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class HomeScrap extends BaseEvent {
  HomeScrap();
}

class HomeScrapDetail extends BaseEvent {
  int id;
  HomeScrapDetail(this.id);
}

class SelectScrap extends BaseEvent {
  final int id;
  SelectScrap({@required this.id});
}

class AddWeight extends BaseEvent {
  final double weight;
  AddWeight({@required this.weight});
}

class SendScrapSelect extends BaseEvent {}

class RemoveScrapSelect extends BaseEvent {
  int idScrap;
  RemoveScrapSelect({@required this.idScrap});
}

class SendListScrapToOrder extends BaseEvent {
  int idOrder;
  SendListScrapToOrder({@required this.idOrder});
}

class CheckSendListScrapToOrder extends BaseEvent {}
