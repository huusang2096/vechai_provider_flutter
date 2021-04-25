import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vecaprovider/src/models/AccountRequest.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/AddAddressResponse.dart';
import 'package:vecaprovider/src/models/AddressRequest.dart';
import 'package:vecaprovider/src/models/ChangePassRequest.dart';
import 'package:vecaprovider/src/models/HostReportResponse.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/models/MultiOrderRequest.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/PrivacyPolicyResonse.dart';
import 'package:vecaprovider/src/models/ReportResponse.dart';
import 'package:vecaprovider/src/models/RequestByHostResponse.dart';
import 'package:vecaprovider/src/models/ScrapDetailResponse.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/models/SendRequesItems.dart';
import 'package:vecaprovider/src/models/UploadImageResponse.dart';
import 'package:vecaprovider/src/models/UploadUser.dart';
import 'package:vecaprovider/src/models/UserAddressResponse.dart';
import 'package:vecaprovider/src/models/basemodel.dart';
import 'package:vecaprovider/src/models/create_order_online_request.dart';
import 'package:vecaprovider/src/models/create_order_online_response.dart';
import 'package:vecaprovider/src/models/login_account_request.dart';
import 'package:vecaprovider/src/models/momo_denominations_response.dart';
import 'package:vecaprovider/src/models/momo_history_withdrawal_response.dart';
import 'package:vecaprovider/src/models/momo_response.dart';
import 'package:vecaprovider/src/models/notification.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/models/token_request.dart';

part 'RestClient.g.dart';

@RestApi(baseUrl: "https://veca.di4l.vn/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("api/auth/login")
  Future<AccountResponse> loginAccount(
      @Body() LoginAccountRequest loginAccountRequest);

  @POST("api/account/upload-image")
  Future<UploadImageResponse> updateImageProfile(@Part('avatar') File image);

  @PUT("api/account/update-information")
  Future<AccountResponse> updateProfile(@Body() UploadUser UploadUser);

  @GET("api/account/get-account-information")
  Future<AccountResponse> getUserProfile();

  @POST("api/address/add-address")
  Future<AddAddressResponse> getAddressRequests(
      @Body() AddressRequest addressRequest);

  @POST("api/collector/add-request-item/{id}")
  Future<BaseModel> addScarpToOrder(
      @Path("id") int id, @Body() SendRequesItems sendRequesItems);

  @GET("api/collector/get-pending-requests")
  Future<OrderResponse> getListOrder();

  @GET("api/collector/get-suggest-requests")
  Future<OrderResponse> getListSuggestOrder();

  @GET("api/address/get-addresses")
  Future<UserAddressResponse> getUserAddress();

  @POST("api/collector/accept-request/{id}")
  Future<BaseModel> acceptRequest(@Path("id") int id);

  @POST("api/collector/accept-multi-requests")
  Future<BaseModel> acceptMultiRequest(
      @Body() MultiOrderRequest multiOrderRequest);

  @POST("api/collector/finish-request/{id}")
  Future<BaseModel> finishRequest(@Path("id") int id);

  @GET("api/collector/get-accepted-requests")
  Future<OrderResponse> getListAcceptedOrder();

  @GET("api/collector/get-accepted-requests-v2")
  Future<OrderResponse> getListOrderPlan();

  @GET("api/collector/get-buy-requests-with-host")
  Future<OrderResponse> getBuyRequestsWithHost();

  @GET("api/host/get-buy-requests/{stauts}")
  Future<OrderResponse> getListOrderByRequest(@Path("stauts") String status);

  @DELETE("api/collector/remove-request/{id}")
  Future<BaseModel> removeRequest(@Path("id") int id);

  @DELETE("/api/host/remove-buy-request/{id}")
  Future<BaseModel> removeHostRequest(@Path("id") int id);

  @GET("api/scrap/get-list-scrap-type")
  Future<ScrapResponse> getListScrap();

  @GET("api/scrap/get-scrap-details/{scrap_id}")
  Future<ScrapDetailResponse> getScrapDetail(@Path("scrap_id") int scrap_id);

  @GET("api/collector/get-report-data")
  Future<ReportResponse> getReportData(
      @Query("start_date") String startDate, @Query("end_date") String endDate);

  @GET("api/host/get-report-data")
  Future<HostReportResponse> getHostReportData(
      @Query("start_date") String startDate, @Query("end_date") String endDate);

  @GET("api/host/get-hosts")
  Future<HostResponse> getListHost();

  @POST("api/host/create-buy-request")
  Future<RequestByHostResponse> createRequestByHost(
      @Body() SendRequesItems hostRequestItem);

  @GET("api/collector/get-buy-request-detail/{id}")
  Future<RequestByHostResponse> getOrderByHost(@Path("id") int id);

  @POST("api/collector/approve-buy-request/{buy_request_id}")
  Future<BaseModel> approveBuyRequest(@Path("buy_request_id") int id);

  @POST("api/notification/update-fcm-token")
  Future<BaseModel> sendFCM(@Body() TokenRequest tokenRequest);

  @GET("api/notification/get-notifications")
  Future<NotificationResponse> getNotification();

  @GET("api/page/get-page-detail-by-slug/privacy-policy")
  Future<PrivacyPolicyResonse> getPrivacyPolicy();

  @POST("api/auth/create-password")
  Future<AccountResponse> createAccount(@Body() AccountRequest accountRequest);

  @PUT("api/account/change-password")
  Future<BaseModel> changePass(@Body() ChangePassRequest changePassRequest);

  @DELETE("api/notification/delete-all-notification")
  Future<BaseModel> removeAllNotification();

  @DELETE("api/notification/delete-notification/{id}")
  Future<BaseModel> removenotification(@Path("id") int productId);

  @GET("api/momo/denominations")
  Future<MomoDenominationsResponse> getListDenominations();

  @POST("api/momo/payout/add")
  Future<MomoResponse> createWithdrawalMomo(
      @Field('amount') int amount, @Field('phone') String phone);

  @GET("api/momo/payout/list")
  Future<MomoHistoryWithdrawalResponse> getListWithdrawalMomo();

  @DELETE("api/momo/payout/remove/{payout_id}")
  Future<BaseModel> deletePayout(@Path("payout_id") int payoutId);

  @POST("api/find-user")
  Future<SearchUserResponse> searchUser(@Field("keyword") String keyword);

  @GET("api/find-user-by-id/{user_id}")
  Future<SearchUserResponse> findExactlyUser(
      @Path("user_id") String providerID);

  @POST("api/host/send-money/{provider_id}")
  Future<BaseModel> sendMoney({
    @Path("provider_id") int providerId,
    @Field("amount") String amount,
    @Field("message") String message,
  });

  @POST("api/host/create-buy-request-direct")
  Future<CreateOrderOnlineResponse> createOrderOnline(
      {@Body() CreateOrderRequest createOrderOnlineRequest});

  @POST("api/host/approve-buy-request-direct/{buy_request_id}")
  Future<CreateOrderOnlineResponse> confirmCreateOrderOnline(
      {@Path("buy_request_id") int buyRequestId,
      @Body() CreateOrderRequest createOrderOnlineRequest});
}
