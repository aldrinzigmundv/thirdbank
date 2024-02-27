import 'dart:convert';

import 'package:http/http.dart';

class EsploraProvider {
  double emergency = 0.0;
  double fast = 0.0;
  double medium = 0.0;
  double slow = 0.0;
  double superslow = 0.0;

  getFees() async {
    try {
      Response response =
          await get(Uri.parse('https://blockstream.info/api/fee-estimates'));
      Map data = jsonDecode(response.body);

      if (response.statusCode == 200) {
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
      } else {
        throw Exception("Getting estimated fees is not successful.");
      }
    } catch (_) {
      rethrow;
    }
  }

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
