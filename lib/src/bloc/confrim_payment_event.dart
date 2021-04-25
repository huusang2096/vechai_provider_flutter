import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class GetOrderByHost extends BaseEvent {
  String id;
  GetOrderByHost(this.id);
}

class ApproveOrderByHost extends BaseEvent {
  int id;
  ApproveOrderByHost(this.id);
}