import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';
import 'base_event.dart';

class ConfrimPaymentBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is GetOrderByHost) {
      yield* getOrderByHost(event.id);
    }

      if(event is ApproveOrderByHost){
      yield* collectorApprove(event.id);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  bool isNumeric(String str) {
    try{
      var value = int.parse(str);
    } on FormatException {
      return false;
    } finally {
      return true;
    }
  }

  Stream<BaseState> getOrderByHost(String id) async* {
    if(isNumeric(id)){
      LoadingState(true);
      var response = await Repository.instance.getOrderByHost(int.parse(id));
      if (response != null && response.success) {
        LoadingState(false);
        yield GetOrderByHostSuccessState(data: response);
      } else {
        LoadingState(false);
        yield ErrorState('Empty');
      }
    } else {
      LoadingState(false);
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> collectorApprove(int id) async* {
      LoadingState(true);
      var response = await Repository.instance.approveBuyRequest(id);
      if (response != null && response.success) {
        LoadingState(false);
        yield ApproveSuccessState(response.message);
      } else {
        LoadingState(false);
        yield ErrorState('Empty');
      }
  }
}