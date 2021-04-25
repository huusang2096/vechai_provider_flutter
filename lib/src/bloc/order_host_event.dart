import 'package:meta/meta.dart';

import 'base_event.dart';

class OrderHostEvent extends BaseEvent {
  String type;
  OrderHostEvent(this.type);
}

class RemoveOrderHostEvent extends BaseEvent {
  int id;
  RemoveOrderHostEvent(this.id);
}
