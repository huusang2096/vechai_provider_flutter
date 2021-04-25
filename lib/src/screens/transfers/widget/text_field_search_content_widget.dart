import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vecaprovider/src/bloc/recharge/bloc.dart';
import 'package:vecaprovider/src/bloc/recharge/recharge_bloc.dart';
import 'package:vecaprovider/src/common/Debouncer.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class TextFieldSearchContent extends StatefulWidget {
  final Size size;
  final TextEditingController controller;
  final RechargeBloc bloc;
  final bool hasReachedSearch;
  final bool isChangeSuffixIcon;

  TextFieldSearchContent(this.size, this.controller, this.bloc,
      this.hasReachedSearch, this.isChangeSuffixIcon);

  @override
  _TextFieldSearchContentState createState() => _TextFieldSearchContentState();
}

class _TextFieldSearchContentState extends State<TextFieldSearchContent> {
  final debounce = Debouncer(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    final colorGrey = Colors.grey;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          padding: EdgeInsets.only(right: 45.0),
          margin:
              EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorGrey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          width: widget.size.width,
          child: TextField(
            controller: widget.controller,
            minLines: 1,
            maxLines: 1,
            onChanged: (query) {
              debounce.run(() {
                widget.bloc.add(SearchUserInit(
                    query: query, hasReachedSearch: widget.hasReachedSearch));
              });
            },
            autofocus: false,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: colorGrey.withOpacity(0.6)),
              prefixIcon: Container(
                padding: EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'img/search.svg',
                  color: colorGrey.withOpacity(0.6),
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: localizedText(context, 'enter_a_name_or_phone_number'),
              contentPadding: EdgeInsets.only(top: 15),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.bloc.add(
                HandleSuffixIcon(textEditingController: widget.controller));
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(right: 25.0),
            child: widget.isChangeSuffixIcon
                ? Icon(Icons.clear, color: colorGrey.withOpacity(0.6))
                : SvgPicture.asset(
                    'img/qr_code.svg',
                    color: colorGrey.withOpacity(0.6),
                  ),
          ),
        )
      ],
    );
  }
}
