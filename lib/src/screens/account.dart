import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/user_profile_bloc.dart';
import 'package:vecaprovider/src/bloc/user_profile_event.dart';
import 'package:vecaprovider/src/bloc/user_profile_state.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/UploadUser.dart';
import 'package:vecaprovider/src/models/facebook_profile.dart';
import 'package:vecaprovider/src/widgets/ProfileSettingsDialog.dart';
import 'package:intl/intl.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class AccountWidget extends StatefulWidget {
  bool isProvider;
  @override
  _AccountWidgetState createState() => _AccountWidgetState();

  AccountWidget(this.isProvider);

  static provider(BuildContext context, bool isProvider) {
    return BlocProvider(
      create: (context) => UserProfileBloc(),
      child: AccountWidget(isProvider),
    );
  }
}

class _AccountWidgetState extends State<AccountWidget> with UIHelper {
  Account _user;
  ProgressDialog pr;
  String lastSelectedValue;
  UserProfileBloc _bloc;
  File imagefile;
  String imageUrl;
  String gender;
  String fullDate;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<UserProfileBloc>(context);
    _bloc.add(GetAccountData());
    intUI();
    super.initState();
  }

  Future getImageLibrary() async {
    var gallery =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    setState(() {
      imagefile = gallery;
      _bloc.add(UploadProfileImage(imagefile));
    });
  }

  Future cameraImage() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    setState(() {
      imagefile = image;
      _bloc.add(UploadProfileImage(imagefile));
    });
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: Text(localizedText(context, 'select_camera')),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(localizedText(context, 'camera')),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: Text(localizedText(context, 'photo_library')),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localizedText(context, 'cancel_normal')),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _bloc.add(GetAccountData());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    var fbToken = '';
    FacebookProfile fbProfile = null;

    _loginFacebook() async {
      final facebookLogin = FacebookLogin();
      await facebookLogin.logOut();
      final result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          return result.accessToken.token;
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          break;
      }
      throw "";
    }

    Future<FacebookProfile> _fetchFacebookProfile(String token) async {
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
      print(graphResponse.body);
      var fbProfile = FacebookProfile.fromRawJson(graphResponse.body);
      return fbProfile;
    }

    _onTapFacebook() async {
      try {
        fbToken = await _loginFacebook();
        fbProfile = await _fetchFacebookProfile(fbToken);
        if (fbProfile.email != null) {
          setState(() {});
        }
      } catch (err) {
        print(err);
      }
    }

    _connectWallet() {}

    _userAvatar() {
      if (_user != null && _user.avatar != null) {
        return CachedNetworkImageProvider(_user.avatar);
      } else {
        return AssetImage('img/user_placeholder.png');
      }
    }

    Future<Null> _handleRefresh() async {
      await new Future.delayed(new Duration(seconds: 3));
      _bloc.add(GetAccountData());
      return null;
    }

    return BlocListener<UserProfileBloc, BaseState>(listener: (context, state) {
      if (state is GetUserProfile) {
        _user = state.account;
        print("USER" + _user.name);
      }

      if (state is UploadProfileImageSuccessState) {
        _user.avatar = state.uploadImageResponse.data.path;
      }

      if (state is UpdateProfileSuccessState) {
        _user = state.accountResponse.data;
      }
    }, child:
        BlocBuilder<UserProfileBloc, BaseState>(builder: (context, state) {
      //translate gender
      gender = _user?.sex ?? 'Male';
      if (gender.toLowerCase() == 'nam') {
        gender = 'Male';
      } else if (gender.toLowerCase() == 'Nữ') {
        gender = 'Female';
      }

      //translate month of year in DateFormat

      if (_user?.dob == null) {
        fullDate = '';
      } else {
        final date = DateFormat('yyyy-MM-dd').format(
            new DateFormat('MMMM dd, yyyy')
                .parse(_user?.dob ?? "January 01, 2020"));
        fullDate = DateFormat(
                'MMMM dd, yyyy', AppLocalizations.of(context).locale.toString())
            .format(DateTime.parse(date));
      }

      return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
              body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _user == null ? "" : _user.name,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      Text(
                                        _user == null ? "" : _user.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(300),
                                      child: CircleAvatar(
                                          backgroundImage: _userAvatar()),
                                    )),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.attach_money_outlined,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                        _user == null
                                            ? ""
                                            : widget.isProvider
                                                ? _user.balance + " đ"
                                                : _user.balance + " đ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ],
                                ),
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              minWidth: 350,
                              height: 55,
                              textColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            //Recharge
                            MaterialButton(
                              onPressed: widget.isProvider
                                  ? () {
                                      Navigator.of(context).pushNamed(
                                          RouteNamed.MY_QR_CODE,
                                          arguments: {
                                            'providerID': _user.id.toString()
                                          });
                                    }
                                  : () {
                                      Navigator.of(context).pushNamed(
                                          RouteNamed.RECHARGE,
                                          arguments: {'myAccount': _user});
                                    },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 45,
                                      height: 45,
                                      child: Icon(
                                        UiIcons.credit_card,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(localizedText(context, 'recharge'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ],
                                ),
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              minWidth: 350,
                              height: 55,
                              textColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            _user != null
                                ? MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          RouteNamed.WITHDRAW,
                                          arguments: {
                                            'withdrawal': _user?.balance ?? '0',
                                            'phonenumber':
                                                _user.phoneCountryCode +
                                                    _user?.phoneNumber
                                          }).then((value) =>
                                          {_bloc.add(GetAccountData())});
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: getLinearGradient(),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            width: 45,
                                            height: 45,
                                            child: Icon(
                                              UiIcons.credit_card,
                                              size: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                              localizedText(
                                                  context, 'withdrawal'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1)
                                        ],
                                      ),
                                    ),
                                    color: Colors.transparent,
                                    elevation: 0,
                                    minWidth: 350,
                                    height: 55,
                                    textColor: Theme.of(context).accentColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  )
                                : SizedBox.shrink(),
                            //history withdrawal
                            _user != null
                                ? MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(
                                              RouteNamed.HISTORY_WITHDRAWAL)
                                          .then((value) =>
                                              {_bloc.add(GetAccountData())});
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: getLinearGradient(),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            width: 45,
                                            height: 45,
                                            child: Icon(
                                              UiIcons.folder_1,
                                              size: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                              localizedText(context,
                                                  'history_withdrawal'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1)
                                        ],
                                      ),
                                    ),
                                    color: Colors.transparent,
                                    elevation: 0,
                                    minWidth: 350,
                                    height: 55,
                                    textColor: Theme.of(context).accentColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  )
                                : SizedBox.shrink(),

                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RouteNamed.CHANGE_PASS);
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 45,
                                      height: 45,
                                      child: Icon(
                                        UiIcons.padlock,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(localizedText(context, 'change_pass'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ],
                                ),
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              minWidth: 350,
                              height: 55,
                              textColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset('img/user.png',
                                width: 25,
                                color: Theme.of(context).accentColor),
                            title: Text(
                              localizedText(context, 'profile_setting'),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              minWidth: 50.0,
                              height: 25.0,
                              child: ProfileSettingsDialog(
                                user: this._user,
                                onChanged: () {},
                                saveUser: (username, sex, dob, email) {
                                  UploadUser uploadUser = new UploadUser();
                                  uploadUser.email = email;
                                  uploadUser.name = username;
                                  uploadUser.sex = sex;
                                  uploadUser.dob = dob;
                                  _bloc.add(UpdateProfile(uploadUser));
                                },
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              localizedText(context, 'phone_number'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              _user == null
                                  ? ""
                                  : _user.phoneCountryCode + _user.phoneNumber,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              localizedText(context, 'full_name'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              _user == null ? "" : _user.name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              localizedText(context, 'email'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              _user == null ? "" : _user.email,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              localizedText(context, 'gender'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              _user == null
                                  ? localizedText(context, 'male')
                                  : localizedText(
                                      context, gender.toLowerCase()),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              localizedText(context, 'birth_date'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              fullDate,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          )));
    }));
  }
}
