import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/signin/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/RequestPhoneNumberResponse.dart';
import 'package:vecaprovider/src/uitls/phone_helper.dart';

class ResetPasswordWidget extends StatefulWidget {
  @override
  _ResetPasswordWidgetState createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget>
    with UIHelper {
  final _phoneController = TextEditingController();
  ProgressDialog pr;
  Country _selected = Country(
      asset: "assets/flags/vn_flag.png",
      dialingCode: "84",
      isoCode: "VN",
      currency: "VND",
      currencyISO: "VND");

  @override
  void initState() {
    _phoneController.addListener(() {
      BlocProvider.of<SignInBloc>(context)
          .add(SignInEmailChange(email: _phoneController.text));
    });

    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider
        .of(context)
        .data;
    pr.style(message: AppLocalizations.of(context).tr('loading'));

    _verifyPassword() async {

      if(_phoneController.text.isEmpty){
         showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, 'not_a_valid_phone_number'),
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
            description: localizedText(context, 'valid_phone_number'),
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

      RequestPhoneNumberResponse requestPhoneNumberResponse = new RequestPhoneNumberResponse();
      requestPhoneNumberResponse.phoneCountryCode = "+"+_selected.dialingCode;
      requestPhoneNumberResponse.phoneNumber = phoneModel.national_number;
      requestPhoneNumberResponse.iSOCode = _selected.isoCode;

      Navigator.of(context)
          .pushNamed(RouteNamed.OTP, arguments: requestPhoneNumberResponse);
    }

    return BlocListener<SignInBloc, SignInState>(listener: (context, state) {
      if (state is SignInLoading) {
        hideKeyboard(context);
        pr.show();
      }

      if (state is SignInDismiss) {
        pr.dismiss();
      }

      if (state is SignInFailure) {
        pr.dismiss();
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: state.error ,
            buttonText: localizedText(context, 'close'),
            image: Image.asset(
                'img/icon_warning.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }

      if (state is SignInSuccess) {}
    }, child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            body: Stack(children: <Widget>[
              Container(height: MediaQuery.of(context).size.height/2, width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: getLinearGradient())),
              Container(
                  height: 300,
                  margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 0),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Theme
                              .of(context)
                              .hintColor
                              .withOpacity(0.15),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(  localizedText(context, 'reset_pass_with_phone_number'),
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
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _verifyPassword,
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
                                child: Text(localizedText(context, 'send'),textAlign: TextAlign.center,
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
              Positioned(
                top: 35,
                left: 20.0,
                right: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme
                                .of(context)
                                .accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      );
    }));
  }
}
