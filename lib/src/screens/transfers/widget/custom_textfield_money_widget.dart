import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vecaprovider/src/bloc/transfers/bloc.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class CustomTextFieldMoneyWidget extends StatefulWidget {
  final TextEditingController controller;
  final String moneyError;
  const CustomTextFieldMoneyWidget({Key key, this.controller, this.moneyError})
      : super(key: key);

  @override
  _CustomTextFieldMoneyWidgetState createState() =>
      _CustomTextFieldMoneyWidgetState();
}

class _CustomTextFieldMoneyWidgetState
    extends State<CustomTextFieldMoneyWidget> {
  TransfersBloc _bloc;
  @override
  Widget build(BuildContext context) {
    final colorGrey = Colors.grey;
    final colorGreen300 = Colors.green[300];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: AbsorbPointer(
        absorbing: false,
        child: TextFormField(
          validator: (value) {
            return validate(value);
          },
          inputFormatters: [NumericTextFormatter()],
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.bottom,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            hintStyle: TextStyle(color: colorGrey.withOpacity(0.5)),
            hintText: localizedText(context, 'enter_the_amount'),
            border: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorGreen300),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            suffixIcon: Container(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('đ'),
                  ],
                )),
          ),
          onChanged: (value) {
            _bloc.add(MoneyChange(money: value));
          },
        ),
      ),
    );
  }

  String validate(var value) {
    if (value.isEmpty) {
      return localizedText(context, 'not_a_valid_withdraw');
    }
    if (int.parse(value.replaceAll(',', '')) <= 1) {
      return localizedText(context, 'min_withdraw_more_than_1');
    }
    return null;
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat('#,###');
      if (int.tryParse(newValue.text.replaceAll(f.symbols.GROUP_SEP, '')) ==
          null) {
        return oldValue;
      }
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));

      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
