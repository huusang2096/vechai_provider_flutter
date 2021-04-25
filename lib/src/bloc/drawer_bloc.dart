import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/drawer_event.dart';
import 'package:vecaprovider/src/bloc/drawer_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

class DrawerBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialDrawerState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is DrawerEventUser) {
      Account account = await Prefs.getAccount();
      yield UserAccountSuccess(account);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }
}
