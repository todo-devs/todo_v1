import 'package:contact_picker/contact_picker.dart';

final ContactPicker _contactPicker = new ContactPicker();

Future<String> getContactPhoneNumber() async {
  Contact contact = await _contactPicker.selectContact();

  return contact.phoneNumber
      .toString()
      .replaceAll('+53', '')
      .replaceAll(' ', '')
      .replaceAll(RegExp(r'([a-zA-Z])'), '')
      .replaceAll('()', '');
}
