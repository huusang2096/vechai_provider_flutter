

import 'package:vecaprovider/src/models/AddressModel.dart';

import 'base_state.dart';

class InitialPlaceAddressState extends BaseState {}

class UploadAddressSuccessState extends BaseState {
  String message;
  AddressModel addressModel;
  UploadAddressSuccessState(this.message, this.addressModel);
}
