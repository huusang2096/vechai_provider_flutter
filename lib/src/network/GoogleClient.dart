import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vecaprovider/src/models/DirectionResponse.dart';

part 'GoogleClient.g.dart';

@RestApi(baseUrl: "https://maps.googleapis.com/maps/api/")
abstract class GoogleClient {
  factory GoogleClient(Dio dio) = _GoogleClient;

  @GET("directions/json")
  Future<DirectionResponse> getDirection(
      @Query("key") String key,
      @Query("origin") String origin,
      @Query("destination") String destination,
      @Query("mode") String mode);
}
