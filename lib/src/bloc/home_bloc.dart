import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/AddressModel.dart';
import 'package:vecaprovider/src/models/Enum.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/models/MultiOrderRequest.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/user_response.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class HomeBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialHomeState();

  bool isProvider = true;
  List<OrderModel> orderModels = [];
  int numberOrder = 0;
  int numberPending = 0;
  List<HostModel> hosts = [];
  AccountResponse account;
  AddressModel addressSelect;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (event is HomeEventData) {
      bool isSkip = await Prefs.isSkip();
      Account account = await Prefs.getAccount();
      isProvider = await Prefs.isProvider();
      if (!isSkip && account.isUpdatedPassword == 0) {
        await Prefs.setSkip(true);
        yield OpenUpdatePassWord();
      } else {
        if (isProvider) {
          yield* loadAddress();
          yield* getOrderByType();
          yield* getAcceptedOrder("accepted");
        } else {
          yield* _getUserProfile();
        }
      }
    }

    if (event is GetListOrder) {
      yield* getOrderByType();
      yield* getAcceptedOrder("accepted");
    }

    if (event is AcceptRequest) {
      yield* acceptRequest(event.id);
    }

    if (event is AcceptAllRequest) {
      yield* acceptMultiRequest();
    }

    if (event is GetListHostRequest) {
      yield* _getListHosts();
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }

    if (event is UnauthenticatedErrorEvent) {
      yield UnauthenticatedState();
    }
  }

  Stream<BaseState> _getUserProfile() async* {
    final response = await Repository.instance.getUserProfile();
    if (response != null) {
      account = response;
      add(GetListHostRequest());
      yield HomeState();
    } else {
      yield ErrorState('login_failed');
    }
  }

  Stream<BaseState> _getListHosts() async* {
    final response = await Repository.instance.getHosts();
    if (response != null && response.data != null) {
      yield LoadingState(false);
      hosts = response.data
          .where((element) => element.id != account.data.host[0].id)
          .toList();
      yield HostsDataSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getOrderByType() async* {
    var response = await Repository.instance.getOrderByType();
    if (response != null && response.success) {
      orderModels = response.data;
      numberOrder = response.data.length;
      yield OrderSuccessState(response.data);
      yield OrderCountSuccessState(response.data.length);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getAcceptedOrder(String type) async* {
    var response = await Repository.instance.getListAcceptedOrder();
    if (response != null && response.success) {
      List<OrderModel> orders =
          response.data.where((order) => order.status == type).toList();
      numberPending = orders.length;
      yield OrderAcceptSuccessState(response.data.length);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> acceptRequest(int id) async* {
    try {
      yield LoadingState(true);
      var response = await Repository.instance.acceptRequest(id);
      yield LoadingState(false);
      if (response != null && response.success) {
        yield AcceptRequestState();
        add(GetListOrder());
      } else {
        yield AcceptRequestFailsState(response.message);
      }
    } catch (e) {
      yield LoadingState(false);
      yield AcceptRequestFailsState(getError(e));
    }
  }

  Stream<BaseState> loadAddress() async* {
    var response = await Repository.instance.getUserAddress();
    if (response != null && response.success && response.data.length != 0) {
      List<AddressModel> address = response.data;
      if (address.length > 0) {
        addressSelect = address[address.length - 1];
      }
    } else {
      yield OpenAddAddress();
    }
  }

  Stream<BaseState> acceptMultiRequest() async* {
    try {
      yield LoadingState(true);
      MultiOrderRequest multiOrderRequest = new MultiOrderRequest();
      List<int> lists = new List();
      orderModels.forEach((order) {
        lists.add(order.id);
      });
      multiOrderRequest.requestIds = lists;
      var response =
          await Repository.instance.acceptMultiRequest(multiOrderRequest);
      if (response != null && response.success) {
        yield AcceptRequestState();
        add(GetListOrder());
        yield LoadingState(false);
      } else {
        yield ErrorState('Empty');
        yield LoadingState(false);
      }
    } catch (e) {
      yield LoadingState(false);
      yield AcceptRequestFailsState(getError(e));
    }
  }
}
