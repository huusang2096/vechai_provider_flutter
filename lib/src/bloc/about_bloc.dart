import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class AboutBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialUserProfileState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if(event is GetAboutData){
      yield* _getAbout();
    }
  }

  Stream<BaseState> _getAbout() async* {
    yield LoadingState(true);
    final response = await Repository.instance.getPrivacyPolicy();
    if (response != null) {
      yield LoadingState(false);
      yield GetAboutDataSucces(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }

}
