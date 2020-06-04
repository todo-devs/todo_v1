import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

void callTo(String number) async {
  android_intent.Intent()
    ..setAction(android_action.Action.ACTION_CALL)
    ..setData(Uri(scheme: "tel", path: number))
    ..startActivity().catchError((e) => print(e));
}