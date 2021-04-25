import 'package:meta/meta.dart';

import 'base_event.dart';

class OrderEvent extends BaseEvent {
  String type;
  OrderEvent(this.type);
}

class OrderFinishEvent extends BaseEvent {
  OrderFinishEvent();
}

class RemoveOrderEvent extends BaseEvent {
  int id;
  RemoveOrderEvent(this.id);
}
