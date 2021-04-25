import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/HostReportResponse.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/models/ReportResponse.dart';

import 'base_state.dart';

class InitialDashBoardState extends BaseState {}

class ReportSuccess extends BaseState {
  ReportResponse reportResponse;
  ReportSuccess(this.reportResponse);
}

class ReportHostSuccess extends BaseState {
  HostReportResponse hostResponse;
  ReportHostSuccess(this.hostResponse);
}