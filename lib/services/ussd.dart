import 'package:ussd/ussd.dart';

Future<void> launchUssd(String ussdCode) async {
  Ussd.runUssd(ussdCode);
}
