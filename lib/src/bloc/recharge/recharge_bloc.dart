import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/recharge/bloc.dart';
import 'package:vecaprovider/src/bloc/recharge/recharge_event.dart';
import 'package:vecaprovider/src/bloc/recharge/recharge_state.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/network/contacts_repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';

class RechargeBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialRechargeState();

  String keyUserorPhone = "";
  bool hasReachedSearch = false;
  List<User> searchUserResponse = [];
  List<Contact> listContact = [];
  bool isChangeSuffixIcon = false;
  bool isLoading = false;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetContact) {
      yield* _getContact();
    }
    if (event is HasReachedSearch) {
      if (!hasReachedSearch) {
        hasReachedSearch = true;
        yield TransferChangeHasReachedState(hasReachedSearch: true);
        await Future.delayed(Duration(seconds: 1));
        yield* _searchUserMore(keyword: keyUserorPhone);
      }
    }
    if (event is SearchUserFromContact) {
      final RegExp regExp =
          RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
      String formatInit = event.phone.replaceAll(RegExp(r'[ (-)-]'), '');
      if (!regExp.hasMatch(formatInit)) {
        //we_cannot_recognize_this_phone_number
        yield CannotRecognizePhoneState();
      } else {
        final result = await PhoneNumber.getParsableNumber(PhoneNumber(
            dialCode: '+84', isoCode: 'VN', phoneNumber: event.phone));
        final format = '+84' + result.replaceAll(' ', '');
        final response = await Repository.instance.searchUser(keyword: format);
        if (response.data.isNotEmpty) {
          yield SearchUserFromContactSuccess(user: response.data.first);
        } else {
          yield SearchUserFromContactFailure();
        }
        await Future.delayed(Duration(milliseconds: 200));
      }
    }
    if (event is SearchUserInit) {
      keyUserorPhone = event.query;
      if (keyUserorPhone.trim().isEmpty) {
        //changeSuffixIcon(false);
        yield ChangeSuffixIconState(isChangeSuffixIcon: false);
        isChangeSuffixIcon = false;
        // hasReachedSearch = false;
        yield TransferSelectUserSearchUserState(
            searchUserResponse: null, currentSearchContent: '');
        return;
      }
      if (event.hasReachedSearch) {
        hasReachedSearch = false;
      }

      // changeSuffixIcon(true);
      yield ChangeSuffixIconState(isChangeSuffixIcon: true);
      isChangeSuffixIcon = true;
      // changeIsLoading(true);
      yield ChangeIsLoading(isLoading: true);
      isLoading = true;

      final response =
          await Repository.instance.searchUser(keyword: keyUserorPhone);

      if (response.success) {
        //changeIsLoading(false);
        hasReachedSearch = true;

        yield ChangeIsLoading(isLoading: false);
        isLoading = false;
        yield TransferSelectUserSearchUserState(
            searchUserResponse: response, currentSearchContent: event.query);
      } else {
        //changeIsLoading(false);
        yield ChangeIsLoading(isLoading: false);
        isLoading = false;
        yield SomethingWentWrong();
      }
    }
    if (event is HandleSuffixIcon) {
      if (!isChangeSuffixIcon) {
        yield HanldleSuffixIconIsFalseState();
      } else {
        if (isLoading) {
          return;
        }
        event.textEditingController.clear();
        yield ChangeSuffixIconState(isChangeSuffixIcon: false);
        isChangeSuffixIcon = false;
        yield TransferSelectUserSearchUserState(
            searchUserResponse: null, currentSearchContent: '');
        hasReachedSearch = false;
      }
    }
    if (event is SearchUserFromDataByQrCode) {
      try {
        yield LoadingState(true);
        final response = await Repository.instance
            .findExactlyUser(providerID: event.providerID);
        if (response.data != null) {
          yield LoadingState(false);
          yield SearchUserFromDataByQrCodeSuccessState(
              user: response.data.first);
        } else {
          yield LoadingState(false);
          yield SearchUserFromDataByQrCodeFailureState();
          await Future.delayed(Duration(seconds: 1));
        }
        await Future.delayed(Duration(milliseconds: 200));
      } catch (e) {
        yield LoadingState(false);
        yield ErrorState('this_user_is_not_yet_use_veca');
      }
    }
  }

  Stream<BaseState> _getContact() async* {
    final contactRepository = ContactsRepository();
    final listContacts = await contactRepository.fetchContacts();

    if (listContacts.isNotEmpty) {
      listContacts.removeWhere((element) => element.phones.isEmpty);
    }

    listContact = listContacts;

    yield GetContactSuccessState(
        listContact: listContact,
        permissionStatus: contactRepository.getPermissionStatus);
  }

  Stream<BaseState> _searchUserMore({String keyword}) async* {
    final response = await Repository.instance.searchUser(keyword: keyword);

    //Not page load
    // final searchResponse = SearchUserResponse(
    //   success: response.success,
    //   message: response.message,
    //   data: searchUserResponse + response.data,
    // );

    if (response.success) {
      hasReachedSearch = false;
      // searchUserResponse = searchResponse.data;
      searchUserResponse = response.data;
      keyUserorPhone = keyword;
      yield TransferSelectUserSearchUserState(
          currentSearchContent: keyUserorPhone, searchUserResponse: response);
    } else {
      ErrorState("Empty");
    }
  }
}
