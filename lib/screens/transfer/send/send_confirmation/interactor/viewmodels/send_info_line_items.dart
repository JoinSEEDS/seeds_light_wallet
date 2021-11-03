import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/utils/cap_utils.dart';

class SendInfoLineItems {
  final String? label;
  final String? text;

  SendInfoLineItems({this.label, this.text});

  static List<SendInfoLineItems> fromAction(EOSAction action) =>
      action.data.entries.map((e) => SendInfoLineItems(label: e.key.inCaps, text: e.value.toString())).toList();
}
