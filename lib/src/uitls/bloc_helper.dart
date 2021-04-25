import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/error_response.dart';

class BlocHelper {
  blocHandleError(Bloc bloc, dynamic error) {
    if (error is String) {
      bloc.add(InternalErrorEvent(error));
    }

    if (error is DioError) {
      var response = error.response?.data ?? {"message": "server_error"};
      if (error.response.statusCode == 401) {
        bloc.add(UnauthenticatedErrorEvent());
      } else {
        if (response is Map) {
          var errResponse = ErrorResponse.fromJson(response);
          bloc.add(InternalErrorEvent(errResponse.message));
        } else if (response is String) {
          var errResponse = ErrorResponse.fromRawJson(response);
          bloc.add(InternalErrorEvent(errResponse.message));
        } else {
          bloc.add(InternalErrorEvent("server_error"));
        }
      }
    }
  }

  String getError(dynamic error) {
    String errorText = "server_error";
    if (error is String) {
      errorText = error;
    }

    if (error is DioError) {
      var response = error.response?.data ?? {"message": "server_error"};
      if (response is Map) {
        var errResponse = ErrorResponse.fromJson(response);
        errorText = errResponse.message;
      } else if (response is String) {
        var errResponse = ErrorResponse.fromRawJson(response);
        errorText = errResponse.message;
      } else {
        errorText = 'server_error';
      }
    }
    return errorText;
  }

  Stream<BaseState> blocHandleMapEvent(BaseEvent event) async* {
//    yield
  }
}
