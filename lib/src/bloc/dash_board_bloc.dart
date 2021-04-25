import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

class DashBoardBloc  extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialDashBoardState();
  DateTime selectedValue = DateTime.now();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    
    if(event is GetReportEvent){
      yield* _getReport(event.start, event.end);
    }

    if(event is GetHostReportEvent){
      yield* _getHostReport(event.start, event.end);
    }
    
    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _getReport(String start, String end) async* {
    var response = await Repository.instance.getReportData(start, end);
    if (response != null && response.success) {
      yield ReportSuccess(response);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> _getHostReport(String start, String end) async* {
    var response = await Repository.instance.getHostReportData(start, end);
    if (response != null && response.success) {
      yield ReportHostSuccess(response);
    } else {
      yield ErrorState('Empty');
    }
  }
}
