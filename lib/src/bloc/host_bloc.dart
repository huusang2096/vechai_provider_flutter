import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class HostBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialProductState();

  List<HostModel> hosts = [];

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is HostSyncData) {
      yield* _getListHosts();
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _getListHosts() async* {
    yield LoadingState(true);
    final response = await Repository.instance.getHosts();
    if (response != null && response.data != null) {
      yield LoadingState(false);
      hosts = response.data;
      yield HostsDataSuccessState(response.data);
    } else {
      yield LoadingState(false);
      yield ErrorState('Empty');
    }
  }
}