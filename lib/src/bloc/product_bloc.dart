import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/models/SendRequesItems.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class ProductBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialProductState();

  int _selectScrapId = -1;
  List<ScrapModel> _productsList = [];
  List<ScrapModel> productsListSelect = [];
  ScrapModel scrapModelSelect;
  double weight = 0;
  double sumPrice = 0;
  bool isProvider = false;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (event is HomeScrap) {
      yield* _getListScrap();
    }

    if (event is HomeScrapDetail) {
      yield* _getScrapDetail(event.id);
    }

    if (event is AddWeight) {
      weight = event.weight;

      double collectorPrice = 0;
      if (scrapModelSelect == null) {
        collectorPrice = 0;
      } else {
        if (isProvider) {
          collectorPrice =
              double.parse(scrapModelSelect.collectorPrice.replaceAll(",", ""));
        } else {
          collectorPrice =
              double.parse(scrapModelSelect.hostPrice.replaceAll(",", ""));
        }
      }
      sumPrice = collectorPrice * weight;
      scrapModelSelect.weight = weight;
      scrapModelSelect.sumPrice = collectorPrice * weight;
      yield AddScrapSuccessState(sumPrice);
    }

    if (event is SendListScrapToOrder) {
      if (productsListSelect.length == 0) {
        yield ErrorState('please_add_scrap_and_weight');
      } else {
        List<RequestItem> listRequestItems = [];
        productsListSelect.forEach((element) {
          RequestItem item = new RequestItem();
          item.scrapId = element.id;
          item.weight = element.weight;
          listRequestItems.add(item);
        });

        SendRequesItems sendRequesItems = new SendRequesItems();
        sendRequesItems.requestItems = listRequestItems;

        yield* _addScarpToOrder(event.idOrder, sendRequesItems);
      }
    }

    if (event is SelectScrap) {
      _selectScrapId = event.id;
      scrapModelSelect =
          _productsList.firstWhere((element) => element.id == _selectScrapId);

      final List<ScrapModel> updatedItems =
          List<ScrapModel>.from(_productsList).map((ScrapModel item) {
        return item.id == _selectScrapId
            ? item.copyWith(isSelect: true)
            : item.copyWith(isSelect: false);
      }).toList();

      add(AddWeight(weight: weight));
      yield GetListScrapSuccessState(updatedItems);
    }

    if (event is RemoveScrapSelect) {
      productsListSelect.removeWhere((element) => element.id == event.idScrap);
      yield RemovecrapSuccessState(productsListSelect);
    }

    if (event is SendScrapSelect) {
      if (scrapModelSelect == null) {
        yield ErrorState('please_select_scrap');
        return;
      }
      if (weight == 0) {
        yield ErrorState('please_add_weight');
        return;
      }
      yield SendListScrapSuccessState(scrapModelSelect);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }

    if (event is CheckSendListScrapToOrder) {
      if (productsListSelect.length == 0) {
        yield ErrorState('please_add_scrap_and_weight');
      } else {
        yield CheckSendListSuccess(productsListSelect);
      }
    }
  }

  Stream<BaseState> _addScarpToOrder(
      int id, SendRequesItems sendRequesItems) async* {
    if (isProvider) {
      yield LoadingState(true);
      final response =
          await Repository.instance.addScarpToOrder(id, sendRequesItems);
      if (response != null && response.success) {
        yield LoadingState(false);
        yield* _finishRequest(id);
      } else {
        yield LoadingState(false);
        yield ErrorState('empty');
      }
    } else {
      yield LoadingState(true);
      final response =
          await Repository.instance.createRequestByHost(sendRequesItems);
      if (response != null && response.success) {
        yield LoadingState(false);
        yield OpenQrcodeSuccessState(response.hostOrder.id);
      } else {
        yield LoadingState(false);
        yield ErrorState('empty');
      }
    }
  }

  Stream<BaseState> _finishRequest(int id) async* {
    final response = await Repository.instance.finishOrder(id);
    if (response != null && response.success) {
      yield LoadingState(false);
      yield SendScrapToOrderSuccessState();
    } else {
      yield LoadingState(false);
      yield ErrorState('empty');
    }
  }

  Stream<BaseState> _getScrapDetail(int id) async* {
    yield LoadingState(true);
    final response = await Repository.instance.getScrapDetail(id);
    if (response != null && response.data != null) {
      yield LoadingState(false);
      yield GetScrapDetailSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('empty');
    }
  }

  Stream<BaseState> _getListScrap() async* {
    isProvider = await Prefs.isProvider();
    final response = await Repository.instance.getListScrap();
    if (response != null && response.data != null) {
      if (isProvider) {
        _productsList = response.data;
      } else {
        _productsList = response.data
            .where((element) => element.hostAcceptScrap == true)
            .toList();
      }
      yield GetListScrapSuccessState(_productsList);
    } else {
      yield ErrorState('empty');
    }
  }
}
