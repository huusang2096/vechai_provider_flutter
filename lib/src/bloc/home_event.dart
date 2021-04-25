import 'package:meta/meta.dart';

import 'base_event.dart';

class HomeEventData extends BaseEvent {}

class GetListOrder extends BaseEvent {}

class AcceptRequest extends BaseEvent {
  int id;
  AcceptRequest(this.id);
}

class AcceptAllRequest extends BaseEvent {}

class GetListHostRequest extends BaseEvent {}