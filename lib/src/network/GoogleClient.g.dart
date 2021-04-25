// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GoogleClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _GoogleClient implements GoogleClient {
  _GoogleClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://maps.googleapis.com/maps/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getDirection(key, origin, destination, mode) async {
    ArgumentError.checkNotNull(key, 'key');
    ArgumentError.checkNotNull(origin, 'origin');
    ArgumentError.checkNotNull(destination, 'destination');
    ArgumentError.checkNotNull(mode, 'mode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'key': key,
      'origin': origin,
      'destination': destination,
      'mode': mode
    };
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'directions/json',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DirectionResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
