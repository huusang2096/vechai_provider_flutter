import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/AddressModel.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class OrdersBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersState();

  List<OrderModel> ordersAccept = [];
  List<OrderModel> ordersFinish = [];
  List<OrderModel> ordersSale = [];

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (event is OrderEvent) {
      if (event.type == "accepted") {
        yield* getListOrderPlan();
      } else {
        yield* getOrderByType(event.type);
      }
    }

    if (event is RemoveOrderEvent) {
      yield* removeOrderType(event.id);
    }

    if (event is OrderFinishEvent) {
      yield* getBuyRequestsWithHost();
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> removeOrderType(int id) async* {
    var response = await Repository.instance.removeAcceptRequest(id);
    if (response != null && response.success) {
      add(OrderEvent("accepted"));
      yield OrderDataRemoveState("delete_order");
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getBuyRequestsWithHost() async* {
    var response = await Repository.instance.getBuyRequestsWithHost();
    if (response != null && response.success) {
      ordersSale = response.data;
      ordersSale.sort((a, b) {
        return b.acceptedAt.compareTo(a.acceptedAt);
      });
      yield OrderDataSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getListOrderPlan() async* {
    var response = await Repository.instance.getListOrderPlan();
    if (response != null && response.success) {
      ordersAccept = response.data;
      yield OrderDataSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getOrderByType(String type) async* {
    var response = await Repository.instance.getListAcceptedOrder();
    if (response != null && response.success) {
      ordersFinish = response.data
          .where((element) => element.status == "finished")
          .toList();

      ordersFinish.sort((a, b) {
        return b.acceptedAt.compareTo(a.acceptedAt);
      });
      yield OrderDataSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }
}
