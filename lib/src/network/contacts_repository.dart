import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsRepository {
  PermissionStatus get getPermissionStatus => _permission;
  PermissionStatus _permission;

  Future<List<Contact>> fetchContacts() async {
    _permission = await _getPermission();
    if (_permission == PermissionStatus.granted) {
      List<Contact> listContact = (await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      ))
          .toList();
      return listContact;
    }
    return [];
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.undetermined) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
