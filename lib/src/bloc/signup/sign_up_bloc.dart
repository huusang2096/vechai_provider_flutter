import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/common/validator.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';
import './bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  var name = "";
  var email = "";
  CountryData _countrySelected;
  ProvincesAddress _stateAddress;
  District _district;
  Wards _wards;

  @override
  SignUpState get initialState => InitialSignUpState();
  final Repository repository;

  SignUpBloc({this.repository});

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {

    if (event is CountryChange) {
      _countrySelected = event.country;
      /* try {
        var provineResponse = await repository.getStateList(id: event.country.id.toString());
        if (provineResponse.data != null && provineResponse.success) {
          yield LoadedStateAddressList(items: provineResponse.data);
        } else if (!provineResponse.success) {
          yield ErrorData(error: provineResponse.message);
        }
      } catch (error) {
        print(error);
        yield ErrorData(error: error);
      }*/
    }

    if(event is StateChange){
      _stateAddress = event.stateAddress;
      /* try {
        var districtsResponse = await repository.getDistrictsList(id: event.stateAddress.id.toString());
        if (districtsResponse.data != null && districtsResponse.success) {
          yield LoadedDistrictAddressList(items: districtsResponse.data);
        } else if (!districtsResponse.success) {
          yield ErrorData(error: districtsResponse.message);
        }
      } catch (error) {
        print(error);
        yield ErrorData(error: error);
      }*/
    }

    if(event is DistrictChange){
      _district = event.district;
      /* try {
        var wardsResponse = await repository.getWardsList(id: event.district.id.toString());
        if (wardsResponse.data != null && wardsResponse.success) {
          yield LoadedWardsAddressList(items: wardsResponse.data);
        } else if (!wardsResponse.success) {
          yield ErrorData(error: wardsResponse.message);
        }
      } catch (error) {
        print(error);
        yield ErrorData(error: error);
      }*/
    }

    if(event is WardsChange){
    /*  try{
        _wards = event.wardsAddress;
        yield SelectWards(items: event.wardsAddress);
      } catch (error){
        yield ErrorData(error: error);
      }*/
    }

    if (event is SignUpEnterName) {
      this.name = event.name;
    }

    if (event is SignUpEnterEmail) {
      this.email = event.email;
    }

    var validateState = _validateInfor();

    yield validateState;

    if (event is SignUpSubmit &&
        validateState.nameError.isEmpty &&
        validateState.emailError.isEmpty ) {
      yield SignUpLoading();
      try {
       /* var userResponse = await repository.signUpEmail(
            name: this.name, email: this.email, password: this.password, referral: this.referral);

        if (userResponse.data != null) {
          yield SignUpSuccess();
        } else if (userResponse.message != null &&
            userResponse.message.isNotEmpty) {
          yield SignUpFailed(error: userResponse.message);
        }*/
      } catch (error) {
        print(error);
        yield SignUpFailed(error: error);
      }
    }
  }

  SignUpValidatorFail _validateInfor() {
    var nameError = "";
    if (this.name.isEmpty) {
      nameError = "name_cannot_empty";
    }

    var emailError = "";
    if (this.email.isEmpty) {
      emailError = "email_cannot_empty";
    } else if (!Validator.isValidEmail(this.email)) {
      emailError = "email_format_invalid";
    }

    return SignUpValidatorFail(
        nameError: nameError,
        emailError: emailError,
    );
  }


}
