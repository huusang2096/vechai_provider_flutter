import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/AddressRequest.dart';

import 'base_event.dart';


class UploadAddress extends BaseEvent {
  AddressRequest addressRequest;

  UploadAddress(this.addressRequest);
}
