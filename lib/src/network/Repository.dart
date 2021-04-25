import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vecaprovider/config/config.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/AccountRequest.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/AddAddressResponse.dart';
import 'package:vecaprovider/src/models/AddressRequest.dart';
import 'package:vecaprovider/src/models/ChangePassRequest.dart';
import 'package:vecaprovider/src/models/DirectionResponse.dart';
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
import 'package:vecaprovider/src/network/RestClient.dart';
import 'package:vecaprovider/src/uitls/device_helper.dart';

import 'GoogleClient.dart';

class Repository {
  final logger = Logger();
  final dio = Dio();
  RestClient _client;
  GoogleClient _googleClient;

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Repository._privateConstructor() {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _client = RestClient(dio);
    _googleClient = GoogleClient(dio);
    reloadHeaders();
  }

  static final Repository instance = Repository._privateConstructor();

  Future<void> reloadHeaders() async {
    final languageCode = await Prefs.getLanguages();
    dio.options.headers["Accept-Language"] = languageCode;
    dio.options.headers["Content-Type"] = "application/json";
    final token = await Prefs.getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN " + token);
  }

  Future<DirectionResponse> getDirections(
      {double fromLat, double fromLng, double toLat, double toLng}) {
    return _googleClient.getDirection(
        Config.apiKey, "$fromLat,$fromLng", "$toLat,$toLng", "driving");
  }

  Future<AccountResponse> loginAccount(LoginAccountRequest accountRequest) {
    return _client.loginAccount(accountRequest);
  }

  Future<UploadImageResponse> updateImageProfile(File file) {
    return _client.updateImageProfile(file);
  }

  Future<AccountResponse> updateProfile(UploadUser UploadUser) {
    return _client.updateProfile(UploadUser);
  }

  Future<ScrapResponse> getListScrap() {
    return _client.getListScrap();
  }

  Future<ScrapDetailResponse> getScrapDetail(int id) {
    return _client.getScrapDetail(id);
  }

  Future<HostResponse> getHosts() {
    return _client.getListHost();
  }

  Future<AddAddressResponse> addAddress(AddressRequest addressRequest) {
    return _client.getAddressRequests(addressRequest);
  }

  Future<BaseModel> addScarpToOrder(int id, SendRequesItems sendRequesItems) {
    return _client.addScarpToOrder(id, sendRequesItems);
  }

  Future<BaseModel> finishOrder(int id) {
    return _client.finishRequest(id);
  }

  Future<RequestByHostResponse> createRequestByHost(
      SendRequesItems hostRequestItem) {
    return _client.createRequestByHost(hostRequestItem);
  }

  Future<RequestByHostResponse> getOrderByHost(int id) {
    return _client.getOrderByHost(id);
  }

  Future<OrderResponse> getListOrderByHost(String status) {
    return _client.getListOrderByRequest(status);
  }

  Future<BaseModel> approveBuyRequest(int requestId) {
    return _client.approveBuyRequest(requestId);
  }

  Future<OrderResponse> getOrderByType() {
    return _client.getListOrder();
  }

  Future<OrderResponse> getListSuggestOrder() {
    return _client.getListSuggestOrder();
  }

  Future<UserAddressResponse> getUserAddress() {
    return _client.getUserAddress();
  }

  Future<BaseModel> acceptRequest(int id) {
    return _client.acceptRequest(id);
  }

  Future<OrderResponse> getListAcceptedOrder() {
    return _client.getListAcceptedOrder();
  }

  Future<OrderResponse> getListOrderPlan() {
    return _client.getListOrderPlan();
  }

  Future<OrderResponse> getBuyRequestsWithHost() {
    return _client.getBuyRequestsWithHost();
  }

  Future<BaseModel> removeAcceptRequest(int id) {
    return _client.removeRequest(id);
  }

  Future<BaseModel> removeHostRequest(int id) {
    return _client.removeHostRequest(id);
  }

  Future<BaseModel> sendFCM(TokenRequest tokenRequest) {
    return _client.sendFCM(tokenRequest);
  }

  Future<NotificationResponse> getNotifications() async {
    return _client.getNotification();
  }

  Future<PrivacyPolicyResonse> getPrivacyPolicy() async {
    return _client.getPrivacyPolicy();
  }

  Future<AccountResponse> createAccpunt(AccountRequest accountRequest) {
    return _client.createAccount(accountRequest);
  }

  Future<AccountResponse> getUserProfile() {
    return _client.getUserProfile();
  }

  Future<BaseModel> changePass(ChangePassRequest changePassRequest) {
    return _client.changePass(changePassRequest);
  }

  Future<ReportResponse> getReportData(String start, String end) {
    return _client.getReportData(start, end);
  }

  Future<HostReportResponse> getHostReportData(String start, String end) {
    return _client.getHostReportData(start, end);
  }

  Future<BaseModel> acceptMultiRequest(MultiOrderRequest multiOrderRequest) {
    return _client.acceptMultiRequest(multiOrderRequest);
  }

  Future<BaseModel> removeAllNotification() {
    return _client.removeAllNotification();
  }

  Future<BaseModel> removeNotificationItem({int notificationID}) {
    return _client.removenotification(notificationID);
  }

  Future<MomoDenominationsResponse> getListDenominations() {
    return _client.getListDenominations();
  }

  Future<MomoResponse> createWithdrawalMomo({int amount, String phone}) {
    return _client.createWithdrawalMomo(amount, phone);
  }

  Future<MomoHistoryWithdrawalResponse> getListWithdrawalMomo() {
    return _client.getListWithdrawalMomo();
  }

  Future<BaseModel> deletePayout(int payoutId) {
    return _client.deletePayout(payoutId);
  }

  Future<SearchUserResponse> searchUser({String keyword}) {
    return _client.searchUser(keyword);
  }

  Future<SearchUserResponse> findExactlyUser({String providerID}) {
    return _client.findExactlyUser(providerID);
  }

  Future<BaseModel> sendMoney({int providerID, String amount, String message}) {
    return _client.sendMoney(
        providerId: providerID, amount: amount, message: message);
  }

  Future<CreateOrderOnlineResponse> createOrderOnline(
      {CreateOrderRequest createOrderRequest}) {
    return _client.createOrderOnline(
        createOrderOnlineRequest: createOrderRequest);
  }

  Future<CreateOrderOnlineResponse> confirmCreateOrderOnline(
      {int buyRequestId, CreateOrderRequest createOrderRequest}) {
    return _client.confirmCreateOrderOnline(
        buyRequestId: buyRequestId,
        createOrderOnlineRequest: createOrderRequest);
  }
}
