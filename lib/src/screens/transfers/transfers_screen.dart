import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/transfers/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/screens/transfers/widget/button_transfer_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/custom_textfield_money_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/custom_textfield_note_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/infomation_contact_widget.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class TransfersScreen extends StatefulWidget {
  TransfersScreen({this.user, this.myAccount});

  @override
  _TransfersScreenState createState() => _TransfersScreenState();

  final User user;
  final Account myAccount;

  static provider(BuildContext context, User user, Account myAccount) {
    return BlocProvider(
      create: (context) => TransfersBloc(),
      child: TransfersScreen(
        user: user,
        myAccount: myAccount,
      ),
    );
  }
}

class _TransfersScreenState extends State<TransfersScreen> with UIHelper {
  ProgressDialog pr;
  TransfersBloc _bloc;
  final _controllerMoney = TextEditingController();
  final _controllerNote = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final colorWhite = Colors.white;
  String textValidate = '';

  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<TransfersBloc>(context);
    _controllerMoney.addListener(() {
      _bloc.add(MoneyChange(money: _controllerMoney.text));
    });
    _controllerNote.addListener(() {
      _bloc.add(NoteChange(note: _controllerNote.text));
    });
    _bloc.add(GetUser(user: widget.user, myAccount: widget.myAccount));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    final _size = MediaQuery.of(context).size;

    return BlocListener<TransfersBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if (state is TransfersTestState) {
          showToast(context, 'newState');
        }
        if (state is ValidateMoneySuccessState) {
          textValidate = localizedText(context, state.value);
        }
        if (state is SendMoneyFailureState) {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description: localizedText(context, 'send_money_fail'),
              buttonText: localizedText(context, 'close'),
              image: Image.asset('img/icon_warning.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              });
        }
        if (state is SendMoneySuccessState) {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description: localizedText(context, 'send_money_success'),
              buttonText: localizedText(context, 'close'),
              image: Image.asset('img/icon_success.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              });
        }
      },
      child: BlocBuilder<TransfersBloc, BaseState>(
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
                  localizedText(context, 'transfers'),
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
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  color: colorWhite,
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 30.0),
                                  child: Column(
                                    children: [
                                      InformationContactWidget(
                                        user: widget.user,
                                        bloc: _bloc,
                                      ),
                                      CustomTextFieldMoneyWidget(
                                        controller: _controllerMoney,
                                        moneyError: _moneyError(state),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTextFieldNoteWidget(
                                    size: _size,
                                    controllerNote: _controllerNote),
                                // SizedBox(
                                //   height: _size.height * 0.1,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ButtonTransferWidget(
                        titleButton: localizedText(context, 'transfers'),
                        size: _size,
                        onPress: () {
                          if (_formKey.currentState.validate()) {
                            _bloc.add(SendMoney(
                                controllerMoney: _controllerMoney,
                                controllerNote: _controllerNote,
                                providerID: widget.user.id));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _moneyError(BaseState state) {
    if (state is ValidateError && state.moneyError.isNotEmpty) {
      return AppLocalizations.of(context).tr(state.moneyError);
    }
    return null;
  }
}
