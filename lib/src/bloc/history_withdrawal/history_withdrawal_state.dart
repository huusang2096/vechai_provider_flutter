import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/momo_history_withdrawal_response.dart';

class HistoryWithdrawalState extends BaseState {}

class GetListWithdrawalMomoSuccess extends BaseState {
  MomoHistoryWithdrawalResponse response;
  GetListWithdrawalMomoSuccess({this.response});
}

class DeletePayoutSuccessState extends BaseState {}
