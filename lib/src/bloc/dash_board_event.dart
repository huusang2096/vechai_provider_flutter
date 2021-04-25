import 'package:meta/meta.dart';

import 'base_event.dart';

class GetReportEvent extends BaseEvent {
  String start;
  String end;
  
  GetReportEvent(this.start, this.end);
}

class GetHostReportEvent extends BaseEvent {
  String start;
  String end;

  GetHostReportEvent(this.start, this.end);
}
