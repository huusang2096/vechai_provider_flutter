import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/ScrapDetailResponse.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';

import 'base_state.dart';

class InitialProductState extends BaseState {}

class GetListScrapSuccessState extends BaseState {
  List<ScrapModel> scraps;

  GetListScrapSuccessState(this.scraps);
}

class RemovecrapSuccessState extends BaseState {
  List<ScrapModel> scraps;

  RemovecrapSuccessState(this.scraps);
}

class GetScrapDetailSuccessState extends BaseState {
  ScrapDetailResponse scrapDetailResponse;

  GetScrapDetailSuccessState(this.scrapDetailResponse);
}

class AddScrapSuccessState extends BaseState {
  double price;

  AddScrapSuccessState(this.price);
}

class SendListScrapSuccessState extends BaseState {
  ScrapModel scrapModel;

  SendListScrapSuccessState(this.scrapModel);
}

class SendScrapToOrderSuccessState extends BaseState {}

class OpenQrcodeSuccessState extends BaseState {
  int id;

  OpenQrcodeSuccessState(this.id);
}

class CheckSendListSuccess extends BaseState {
  final List<ScrapModel> listScrapModel;

  CheckSendListSuccess(this.listScrapModel);
}
