import 'package:mobx/mobx.dart';

import 'package:intl/intl.dart';

part 'formatting.g.dart';

class FormattingProvider = _FormattingProvider with _$FormattingProvider;

abstract class _FormattingProvider with Store {
  String formatTimeStamp(int? timestamp) {
    int result = timestamp ?? 0;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(result * 1000);
    String formatted = DateFormat.yMMMMd().add_jm().format(dateTime);
    if (formatted == 'January 1, 1970 8:00 AM') {
      return "Pending";
    } else {
      return formatted;
    }
  }

  formatConfirmations(
      {required int blockchainHeight, required int transactionHeight}) {
    int difference = blockchainHeight - transactionHeight;
    if (difference == blockchainHeight || difference > blockchainHeight) {
      return 0;
    } else {
      return difference;
    }
  }

  int formatBlockHeight(int? blockheight) {
    return blockheight ?? 0;
  }

  int getFee(int? fee) {
    return fee ?? 0;
  }

  String formatFee(int? fee) {
    int finalFee = fee ?? 0;
    if (finalFee == 0) {
      return "Pending";
    } else {
      return finalFee.toString();
    }
  }

  String formatSpeed(String speed) {
    if (speed == 'Highest Fee, Settles Fastest (<10 minutes)') {
      return 'Emergency';
    } else if (speed == 'Higher Fee, Settles Faster (around 10 minutes)') {
      return 'Fast';
    } else if (speed == 'Moderate Fee, Moderate Settlement (around 1 hour)') {
      return 'Medium';
    } else if (speed == 'Lower Fee, Settles Slower (around 24 hours)') {
      return 'Slow';
    } else if (speed == 'Lowest Fee, Settles Slowest (around 7 days)') {
      return 'Super Slow';
    } else {
      return 'Medium';
    }
  }
}
