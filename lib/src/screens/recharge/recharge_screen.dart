import 'package:contacts_service/contacts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/recharge/bloc.dart';
import 'package:vecaprovider/src/bloc/recharge/recharge_bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/screens/recharge/shimmer/contact_shimmer.dart';
import 'package:vecaprovider/src/screens/transfers/widget/item_contact_transfer_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/item_contact_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/separator_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/text_field_search_content_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/title_widget.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({Key key, this.myAccount}) : super(key: key);

  @override
  _RechargeScreenState createState() => _RechargeScreenState();

  final Account myAccount;

  static provider(BuildContext context, Account myAccount) {
    return BlocProvider<RechargeBloc>(
      create: (context) => RechargeBloc(),
      child: RechargeScreen(
        myAccount: myAccount,
      ),
    );
  }
}

class _RechargeScreenState extends State<RechargeScreen> with UIHelper {
  TextEditingController _searchController = TextEditingController();
  ScrollController _searchScrollController = ScrollController();
  List<Contact> _listContact = [];
  SearchUserResponse _searchUserResponse;
  PermissionStatus _permissionStatus;
  //Widget _buildItem;
  bool hasReachedSearch = false;
  bool isLoading = false;
  bool isChangeSuffixIcon = false;

  RechargeBloc _bloc;
  ProgressDialog pr;

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<RechargeBloc>(context);
    _bloc.add(GetContact());
    _searchScrollController.addListener(() {
      double maxScroll = _searchScrollController.position.maxScrollExtent;
      double currentScroll = _searchScrollController.position.pixels;
      if (maxScroll - currentScroll < 10.0) {
        //bloc.hasReachedSearch();
        _bloc.add(HasReachedSearch());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final size = MediaQuery.of(context).size;

    return BlocListener<RechargeBloc, BaseState>(
      listener: (context, state) async {
        handleCommonState(context, state);
        if (state is GetContactSuccessState) {
          _listContact = state.listContact;
          _permissionStatus = state.permissionStatus;
        }
        if (state is TransferSelectUserSearchUserState) {
          _searchUserResponse = state.searchUserResponse;
        }
        if (state is CannotRecognizePhoneState) {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description: localizedText(
                  context, 'we_cannot_recognize_this_phone_number'),
              buttonText: localizedText(context, 'close'),
              image: Image.asset('img/icon_warning.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              });
        }
        if (state is SearchUserFromContactFailure) {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description:
                  localizedText(context, 'this_user_is_not_yet_use_veca'),
              buttonText: localizedText(context, 'close'),
              image: Image.asset('img/icon_warning.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              });
        }

        if (state is TransferChangeHasReachedState) {
          hasReachedSearch = state.hasReachedSearch;
        }
        if (state is SearchUserFromContactSuccess) {
          // _searchUserResponse.data.first = state.user;
          Navigator.of(context).pushNamed(RouteNamed.TRANSFERS,
              arguments: {'user': state.user, 'myAccount': widget.myAccount});
        }
        if (state is SomethingWentWrong) {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description: localizedText(context, 'something_went_wrong'),
              buttonText: localizedText(context, 'close'),
              image: Image.asset('img/icon_warning.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              });
        }
        if (state is TransferLoadMoreError) {
          return _buildWidgetLoadMore = Container(
            height: 40.0,
            child: Center(
              child: Text(
                localizedText(context, 'no_matching_results_were_found'),
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }
        if (state is ChangeIsLoading) {
          isLoading = state.isLoading;
        }
        if (state is ChangeSuffixIconState) {
          isChangeSuffixIcon = state.isChangeSuffixIcon;
        }
        if (state is HanldleSuffixIconIsFalseState) {
          final data = await Navigator.of(context).pushNamed(
              RouteNamed.TRANSFER_SCAN_QRCODE,
              arguments: {'isPopAndReturnData': true}) as Map;
          if (data != null) {
            final providerID = data['data'];
            _bloc.add(SearchUserFromDataByQrCode(providerID: providerID));
          }
        }
        if (state is SearchUserFromDataByQrCodeFailureState) {
          showToast(context, 'this_user_is_not_yet_use_veca');
        }
        if (state is SearchUserFromDataByQrCodeSuccessState) {
          Navigator.of(context).pushNamed(RouteNamed.TRANSFERS,
              arguments: {'user': state.user, 'myAccount': widget.myAccount});
        }
      },
      child: BlocBuilder<RechargeBloc, BaseState>(
        builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(UiIcons.return_icon,
                      color: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: getLinearGradient())),
                elevation: 0,
                title: Text(
                  localizedText(context, 'select_recipients'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Container(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldSearchContent(size, _searchController, _bloc,
                            hasReachedSearch, isChangeSuffixIcon),
                        _searchUserResponse == null
                            ? _listFromContact(
                                size, _listContact, _permissionStatus)
                            : _listResultSearch(
                                size: size,
                                scrollController: _searchScrollController,
                                listUser: _searchUserResponse.data,
                                state: state),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidgetLoadMore = SizedBox(
    height: 50.0,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  Widget _listFromContact(
      Size size, List<Contact> listContact, PermissionStatus permissionStatus) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(titleKey: 'from_contacts'),
          listContact == null
              ? ContactShimmer()
              : (listContact.isEmpty
                  ? buildNotificationPermission(permissionStatus)
                  : buildListContact(size, listContact)),
        ],
      ),
    );
  }

  Widget buildNotificationPermission(PermissionStatus permissionStatus) {
    String text;
    if (permissionStatus == PermissionStatus.granted) {
      text = localizedText(context, 'contacts_are_empty');
    }
    if (permissionStatus == PermissionStatus.denied) {
      text = localizedText(context, 'contacts_access_has_been_denied');
    }
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      text =
          localizedText(context, 'contacts_access_has_been_denied_permanently');
    }
    if (text == null) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.withOpacity(0.65),
          ),
        ),
      ),
    );
  }

  Widget buildListContact(Size size, List<Contact> listContact) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 15.0),
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Contact contact = listContact.elementAt(index);
              return ItemContactTransferWidget(
                title: contact.displayName,
                onPress: () {
                  _bloc.add(SearchUserFromContact(
                    phone: contact.phones.isEmpty
                        ? ''
                        : contact.phones.elementAt(0).value,
                  ));
                },
                imgAvatar: contact.initials(),
                size: size,
                subTitle: contact.phones.isEmpty
                    ? ''
                    : contact.phones.elementAt(0).value,
              );
            },
            separatorBuilder: (context, index) {
              return SeparatorWidget();
            },
            itemCount: listContact.length),
      ),
    );
  }

  Widget _listResultSearch(
      {Size size,
      ScrollController scrollController,
      List<User> listUser,
      BaseState state}) {
    return isLoading
        ? ContactShimmer()
        : listUser.isEmpty
            ? _buildNullResultSearch()
            : _buildListResultSearch(listUser, scrollController, state);
  }

  Widget _buildNullResultSearch() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(titleKey: 'search_results'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            margin: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Text(
                localizedText(
                    context, 'cant_find_this_user_please_try_another_keyword'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.65),
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListResultSearch(
      List<User> listUser, ScrollController scrollController, BaseState state) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(titleKey: 'search_results'),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              child: ListView.separated(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index >= listUser.length) {
                    return _buildWidgetLoadMore;
                  }
                  final data = listUser[index];
                  final phoneFull = data.phoneCountryCode + data.phoneNumber;
                  return ItemContactWidget(
                    imgUrl: data?.avatar != null && data.avatar.isNotEmpty
                        ? data.avatar
                        : null,
                    onPress: () {
                      // navigator.pushNamed(RouteGenerator.transferScreen,
                      //     arguments: {'user': data});
                      Navigator.of(context).pushNamed(RouteNamed.TRANSFERS,
                          arguments: {
                            "user": data,
                            "myAccount": widget.myAccount
                          });
                    },
                    size: size,
                    showStatus: false,
                    pathSvg: 'img/avatar_icon.svg',
                    subTitle: phoneFull ?? data.email ?? '',
                    title: data?.name ?? '',
                  );
                },
                separatorBuilder: (context, index) {
                  return SeparatorWidget();
                },
                itemCount:
                    hasReachedSearch ? listUser.length + 1 : listUser.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
