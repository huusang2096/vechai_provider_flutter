import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/login_account_bloc.dart';
import 'package:vecaprovider/src/bloc/login_account_event.dart';
import 'package:vecaprovider/src/bloc/login_account_state.dart';
import 'package:vecaprovider/src/bloc/signin/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/login_account_request.dart';
import 'package:vecaprovider/src/uitls/device_helper.dart';
import 'package:vecaprovider/src/uitls/phone_helper.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();

  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginAccountBloc(),
      child: SignInWidget(),
    );
  }
}

class _SignInWidgetState extends State<SignInWidget> with UIHelper {
  final _phoneController = TextEditingController();
  ProgressDialog pr;
  bool _showPassword = false;
  final _passwordController = TextEditingController();

  Country _selected = Country(
      asset: "assets/flags/vn_flag.png",
      dialingCode: "84",
      isoCode: "VN",
      currency: "VND",
      currencyISO: "VND");
  LoginAccountBloc _bloc;

  @override
  void initState() {

    _bloc = BlocProvider.of<LoginAccountBloc>(context);

    _passwordController.addListener(() {
      _bloc.add(PasswordChange(_passwordController.text));
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _forgotPass() {
      Navigator.of(context)
            .pushNamed(RouteNamed.FORGOT);
    }

    _loginWithPhone() async {
      if(_phoneController.text.isEmpty){
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description:localizedText(context,'not_a_valid_phone_number'),
            buttonText: localizedText(context, 'close'),
            image: Image.asset(
                'img/icon_warning.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
        return;
      }
      final phoneModel = await PhoneHelper.parsePhone(_phoneController.text.toString(),_selected.isoCode);

      if(phoneModel == null){
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description:localizedText(context, 'valid_phone_number'),
            buttonText: localizedText(context, 'close'),
            image: Image.asset(
                'img/icon_warning.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
        return;
      }
      LoginAccountRequest loginAccountRequest = new LoginAccountRequest();
      loginAccountRequest.phoneCountryCode = "+"+_selected.dialingCode;
      loginAccountRequest.phoneNumber = phoneModel.national_number;
      loginAccountRequest.isoCode =_selected.isoCode;
      loginAccountRequest.accountType = 2;
      loginAccountRequest.deviceId = await DeviceHelper.instance.getId();
      loginAccountRequest.password = _passwordController.text.toString();

      _bloc.add(LoginWithAccount(loginAccountRequest));
    }

    _passwordError(BaseState state) {
      if (state is LoginWithPasswordValidateError && state.error.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.error);
      }
      return null;
    }

    return BlocListener<LoginAccountBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if(state is LoginAccountSuccess){
        print("LOGIN");
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/Tabs", (Route<dynamic> route) => false,
              arguments: 2);
      }
    }, child: BlocBuilder<LoginAccountBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(children: <Widget>[
              Container(height: MediaQuery.of(context).size.height/2, width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: getLinearGradient())),
              Container(
                height: 400,
                margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context)
                            .hintColor
                            .withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(  localizedText(context, 'login_with_phone_number'),
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).hintColor, //                   <--- border color
                            width: 1.0,
                          ),
                        ),
                        child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 0,
                            child: CountryPicker(
                              showDialingCode: true,
                              dense: false,
                              showFlag: false,
                              //displays flag, true by default
                              showName: false,
                              //displays country name, true by default
                              showCurrency: false,
                              //eg. 'British pound'
                              showCurrencyISO: false,
                              onChanged: (Country country) {
                                setState(() {
                                  _selected = country;
                                });
                              },
                              selectedCountry: _selected,
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2,
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                hintText: localizedText(context, 'input_phone_number'),
                                //S.of(context).email_addr,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .merge(
                                  TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                              ),
                              controller: _phoneController,
                            ),
                          )
                        ],
                      ),),
                      SizedBox(height: 10),
                      new TextField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2,
                        keyboardType: TextInputType.text,
                        obscureText: !_showPassword,
                        decoration: new InputDecoration(
                            hintText:localizedText(context, 'password'),
                            //S.of(context).password,
                            hintStyle: Theme
                                .of(context)
                                .textTheme
                                .subtitle2
                                .merge(
                              TextStyle(color: Theme
                                  .of(context)
                                  .accentColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Theme.of(context).hintColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Theme.of(context).hintColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Theme.of(context).hintColor),
                            ),
                            prefixIcon: Icon(
                              UiIcons.padlock_1,
                              color: Theme
                                  .of(context)
                                  .accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              color:
                              Theme
                                  .of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            errorText: _passwordError(state)),
                        controller: _passwordController,
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        onPressed: () {
                          _forgotPass();
                        },
                        child: Text(
                          localizedText(context, 'forgot_pass'),
                          //S.of(context).forgot_pass,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText2,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: ()  {
                          _loginWithPhone();
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: getLinearGradient(),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(localizedText(context, 'login'),textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ])),
      );
    }));
  }
}
