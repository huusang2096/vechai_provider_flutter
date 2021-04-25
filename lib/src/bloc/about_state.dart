

import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/PrivacyPolicyResonse.dart';

class InitialAboutState extends BaseState {}

class GetAboutDataSucces extends BaseState {
  PrivacyPolicyResonse aboutResponse;
  GetAboutDataSucces(this.aboutResponse);
}

