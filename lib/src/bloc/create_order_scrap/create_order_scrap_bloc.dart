import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/create_order_scrap/create_order_scrap_event.dart';
import 'package:vecaprovider/src/bloc/create_order_scrap/create_order_scrap_state.dart';
import 'package:vecaprovider/src/models/create_order_online_request.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';

class CreateOrderScrapBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => CreateOrderScrapState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  int requestTime = 1;
  List<RequestItemOrder> listItemOrder = [];
  CreateOrderRequest createOrderRequest;

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is SendOrderRequest) {
      event.listScrapModel.forEach((element) {
        final item = RequestItemOrder();
        item.scrapId = element.id;
        item.weight = element.weight;
        listItemOrder.add(item);
      });
      createOrderRequest = CreateOrderRequest(
        requestTime: requestTime,
        requestItems: listItemOrder,
      );
      yield LoadingState(true);
      final response = await Repository.instance
          .createOrderOnline(createOrderRequest: createOrderRequest);
      if (response != null && response.success) {
        yield LoadingState(false);
        yield CreateOrderOnlineSuccessState(response: response);
      } else {
        yield LoadingState(false);
        yield ErrorState('server_error');
      }
    }
    if (event is ConfirmCreateOrder) {
      yield LoadingState(true);
      final response = await Repository.instance.confirmCreateOrderOnline(
          buyRequestId: event.hostOderId,
          createOrderRequest: createOrderRequest);
      if (response != null) {
        yield LoadingState(false);
        yield ConfirmCreateOrderSuccessState(isCreateOrderSuccess: true);
      } else {
        yield LoadingState(false);
        yield ErrorState('server_error');
      }
    }
  }
}
