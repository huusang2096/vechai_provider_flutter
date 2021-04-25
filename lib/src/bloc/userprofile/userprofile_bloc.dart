import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/user_response.dart';
import './bloc.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as multipart;


class UserprofileBloc extends Bloc<UserprofileEvent, UserprofileState> {
  var userName = '';
  var sex = '';
  var dob= '';

  @override
  UserprofileState get initialState => InitialUserprofileState();

  final Repository repository;

  Future<String> getUserToken() {
    return Prefs.getUser().then((user) => user == null ? "" : user.apiToken);
  }

  UserprofileBloc({this.repository});

  @override
  Stream<UserprofileState> mapEventToState(
    UserprofileEvent event,
  ) async* {
    if(event is UpdateUserProfile){
      this.userName = event.username;
      this.sex = event.sex;
      this.dob = event.dob;
      yield UpdateUsernameLoading();
        /*try {
          var userResponse = await repository.updateUserProfile(
              username: this.userName, sex: this.sex, dob: this.dob);
          if (userResponse.data != null) {
            _saveUser(userResponse.data);
          }
          yield UsernameSuccess(message : userResponse.message);
        } catch (error) {
          yield UpdateUsernameFailure(error: error.toString());
        } finally {
          yield UpdateUsernameDismiss();
        }*/
    }

    if(event is LoadSubscriptionUser){
      /*try {
        var  subscriptionUser = await repository.getSubscriptionCurrent();
        if (subscriptionUser.data != null) {
          yield SubscriptionCurrent(purchaseSubscriptionResponse: subscriptionUser);
        }
        yield UsernameSuccess(message : subscriptionUser.message);
      } catch (error) {
        yield UpdateUsernameFailure(error: error.toString());
      }*/
    }

    if(event is UpdateUserAvartar){
      yield UpdateUsernameLoading();
      try {
        const url = Const.BASE_URL + "/api/account/upload-avatar";

        Map<String, String> headers = { "Authorization": 'Bearer ' + await getUserToken()};

        var stream = new multipart.ByteStream(DelegatingStream.typed(event.imageFile.openRead()));
        var length = await event.imageFile.length();

        var uri = Uri.parse(url);

        var request = new multipart.MultipartRequest("POST", uri);

        var multipartFile = new multipart.MultipartFile('image', stream, length,
            filename: basename(event.imageFile.path));

        request.files.add(multipartFile);
        request.headers.addAll(headers);

        var response = await request.send();
        response.stream.transform(utf8.decoder).listen((value) {
         /* if (response.statusCode >= 200 && response.statusCode < 400) {
            // If the call to the server was successful, parse the JSON
            UserResponse response = UserResponse.fromJson(json.decode(value.toString()));
            try {
              if(response.success){
                _saveUser(response.data);
              }
            } catch (error) {
              throw Exception('load_data_failed');
            }
          } else {
            // If that call was not successful, throw an error.
            throw Exception('load_data_failed');
          }*/
        });
        yield UsernameSuccess(message : "");
      } catch (error) {
        yield UpdateUsernameFailure(error: error.toString());
      } finally {
        yield UpdateUsernameDismiss();
      }
    }

    if (event is FetchOrderList) {
      /*try {
        var orderReposne = await repository.getListOrder();
        if (orderReposne.success) {
          yield LoadedOrders(items: orderReposne.data);
        } else {
          yield LoadOrdersFailure(error: orderReposne.message);
        }
      } catch (error) {
        yield LoadOrdersFailure(error: error.toString());
      }*/
    }

    if (event is LoadData) {
      var user = await Prefs.getUser();
      if (user != null) {
        yield LoadUser(user: user);
      }
      var skip = await Prefs.getUser() == null ? true : false;
      yield LoadSkip(skip: skip);
    }
  }

  _saveUser(User user) async {
    User userOld = await Prefs.getUser();
    user.apiToken = userOld.apiToken;
    await Prefs.saveUser(user);
    if (user.apiToken != null && user.apiToken.isNotEmpty) {
      await Prefs.saveToken(user.apiToken);
      await Prefs.setNeedToShowWalkThrough(false);
    }
  }
}
