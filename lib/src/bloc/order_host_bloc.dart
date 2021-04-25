import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';
import 'base_state.dart';

class OrderHostBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersHostState();

  List<OrderModel> ordersPending = [];
  List<OrderModel> ordersFinish = [];

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (event is OrderHostEvent) {
      yield* getOrderByType(event.type);
    }

    if (event is RemoveOrderHostEvent) {
      yield* removeOrderHostType(event.id);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> removeOrderHostType(int id) async* {
    var response = await Repository.instance.removeHostRequest(id);
    if (response != null && response.success) {
      add(OrderHostEvent("pending"));
      yield OrderHostRemoveState("delete_order");
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getOrderByType(String type) async* {
    var response = await Repository.instance.getListOrderByHost(type);
    if (response != null && response.success) {
      if (type == "pending") {
        ordersPending = response.data;
        ordersPending.sort((a, b) {
          return b.createdAt.compareTo(a.createdAt);
        });
      } else if (type == "finished") {
        ordersFinish = response.data;
        ordersFinish.sort((a, b) {
          return b.createdAt.compareTo(a.createdAt);
        });
      }
      yield OrderHostSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }
}
