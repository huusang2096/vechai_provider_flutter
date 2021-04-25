import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/momo_denominations_response.dart';

class WithdrawState extends BaseState {}

class WithdrawSuccessState extends BaseState {
  String message;
  String price;
  WithdrawSuccessState(this.message, this.price);
}

class GetListDenominationSuccess extends BaseState {
  MomoDenominationsResponse response;

  GetListDenominationSuccess(this.response);
}

class SelectDenominationState extends BaseState {
  int id;
  SelectDenominationState(this.id);
}

class ChangeSuffixIconState extends BaseState {
  bool changeSuffixIcon;
  ChangeSuffixIconState(this.changeSuffixIcon);
}

class ISShowMOMOState extends BaseState {
  bool isShow;
  ISShowMOMOState(this.isShow);
}
