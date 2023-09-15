import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:http/http.dart';

part 'esplora.g.dart';

class EsploraProvider = _EsploraProvider with _$EsploraProvider;

abstract class _EsploraProvider with Store {
  @observable
  double emergency = 0.0;

  @observable
  double fast = 0.0;

  @observable
  double medium = 0.0;

  @observable
  double slow = 0.0;

  @observable
  double superslow = 0.0;

  @action
  getFees() async {
    try {
      Response response =
          await get(Uri.parse('https://blockstream.info/api/fee-estimates'));
      Map data = jsonDecode(response.body);

      //asap transactions
      emergency = data['1'] * 2.0;

      //10 min transactions
      fast = data['1'];

      //one hour transactions
      medium = data['6'];

      //24 hrs
      slow = data['144'];

      //7 days
      superslow = data['1008'];
    } on Exception catch (_) {
      rethrow;
    }
  }

  @action
  double getFee(String speed) {
    if (speed == 'Emergency') {
      return emergency;
    } else if (speed == 'Fast') {
      return fast;
    } else if (speed == 'Medium') {
      return medium;
    } else if (speed == 'Slow') {
      return slow;
    } else if (speed == 'Super Slow') {
      return superslow;
    } else {
      return medium;
    }
  }
}
