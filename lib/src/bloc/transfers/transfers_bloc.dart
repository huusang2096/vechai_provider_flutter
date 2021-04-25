import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/transfers/bloc.dart';
import 'package:vecaprovider/src/common/validator.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';

class TransfersBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialTransfersState();

  String money = '';
  String note = '';
  User user;
  Account myAccount;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(error, stacktrace);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetUser) {
      user = event.user;
      myAccount = event.myAccount;
    }
    if (event is MoneyChange) {
      money = event.money;
    }
    if (event is NoteChange) {
      note = event.note;
    }
    if (event is SendMoney) {
      final note = event.controllerNote.text.isEmpty
          ? 'Chuyen Tien'
          : event.controllerNote.text;
      final money = int.parse(event.controllerMoney.text.replaceAll(',', ''));
      if (money > 0) {
        yield LoadingState(true);
        final response = await Repository.instance.sendMoney(
          providerID: event.providerID,
          amount: money.toString(),
          message: note,
        );
        if (!response.success) {
          yield LoadingState(false);
          yield SendMoneyFailureState();
        } else {
          yield LoadingState(false);
          yield SendMoneySuccessState();
        }
      }
    }

    var validateState = _validateError();

    yield validateState;
  }

  ValidateError _validateError() {
    String moneyError = '';
    if (money.isEmpty || money == null) {
      moneyError = 'amount_must_be_greater_than';
    } else if (num.tryParse(money) == null) {
      moneyError = 'please_input_numeric';
    }

    return ValidateError(moneyError: moneyError);
  }
}
