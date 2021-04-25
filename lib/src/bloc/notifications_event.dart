import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class NotificationEvent extends BaseEvent {
  NotificationEvent();
}

class RemoveAllNotification extends BaseEvent {}

class RemoveNotificationItemEvent extends BaseEvent {

  final int notificationID;

  RemoveNotificationItemEvent({this.notificationID});

}