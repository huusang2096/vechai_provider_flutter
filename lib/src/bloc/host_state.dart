import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
class InitialHostState extends BaseState {}

class HostsDataSuccessState extends BaseState {
  List<HostModel> hosts;

  HostsDataSuccessState(this.hosts);
}
