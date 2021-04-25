import 'package:flutter/material.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class CustomTextFieldNoteWidget extends StatelessWidget {
  const CustomTextFieldNoteWidget({
    Key key,
    @required this.size,
    @required this.controllerNote,
  }) : super(key: key);

  final Size size;
  final TextEditingController controllerNote;

  @override
  Widget build(BuildContext context) {
    // final cubit = context.bloc<TransferCubit>();
    // final state = cubit.state;
    final colorWhite = Colors.white;
    final colorGrey = Colors.grey;
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      color: colorWhite,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizedText(context, 'note'),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            // decoration: BoxDecoration(
            //     border: Border.all(color: colorGrey),
            //     borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              validator: (value) {
                if (value.length > 255) {
                  return localizedText(context, 'not_larger_than_characters');
                }
                return null;
              },
              controller: controllerNote,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                hintText: localizedText(context, 'to_characters'),
                hintStyle: TextStyle(color: colorGrey.withOpacity(0.5)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: outlineInputBorder(color: colorGrey, radius: 10),
                focusedBorder:
                    outlineInputBorder(color: Colors.green[300], radius: 10),
                errorBorder:
                    outlineInputBorder(color: Colors.redAccent, radius: 10),
                focusedErrorBorder:
                    outlineInputBorder(color: Colors.redAccent, radius: 10),
                enabledBorder: outlineInputBorder(color: colorGrey, radius: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({double radius, Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color),
    );
  }
}
