import 'package:flutter/material.dart';

import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/wallet.dart';

import 'package:thirdbank/pages/setup pages/mnemonicquestionpage.dart';
import 'package:thirdbank/pages/setup pages/generatemnemonicpage.dart';
import 'package:thirdbank/pages/setup pages/restoremnemonicpage.dart';
import 'package:thirdbank/pages/setup pages/authenticationquestionpage.dart';
import 'package:thirdbank/pages/homepage.dart';
import 'package:thirdbank/pages/transactionpages/sendpage.dart';
import 'package:thirdbank/pages/transactionpages/receivepage.dart';
import 'package:thirdbank/pages/transactionpages/transactionconfirmationpage.dart';

goToHomePage(
    {required BuildContext context,
    required WalletProvider wallet,
    required StorageProvider storage}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                wallet: wallet,
                storage: storage,
              )),
      (Route<dynamic> route) => false);
}

void goToMnemonicQuestionPage(
    {required BuildContext context,
    required WalletProvider wallet,
    required StorageProvider storage}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MnemonicQuestionPage(
                wallet: wallet,
                storage: storage,
              )));
}

goToRestoreMnemonicPage(
    {required BuildContext context,
    required WalletProvider wallet,
    required StorageProvider storage}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RestoreMnemonicPage(
                wallet: wallet,
                storage: storage,
              )));
}

goToGenerateMnemonicPage(
    {required BuildContext context,
    required WalletProvider wallet,
    required StorageProvider storage}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GenerateMnemonicPage(
                wallet: wallet,
                storage: storage,
              )));
}

goToAuthenticationQuestionPage(
    {required BuildContext context,
    required WalletProvider wallet,
    required StorageProvider storage}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AuthenticationQuestionPage(
                wallet: wallet,
                storage: storage,
              )));
}

goToSendBitcoinPage(
    {required BuildContext context, required WalletProvider wallet}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SendBitcoinPage(
                wallet: wallet,
              )));
}

goToReceivePage(
    {required BuildContext context, required WalletProvider wallet}) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReceivePage(
                wallet: wallet,
              )));
}

goToTransactionConfirmationPage(
    {required BuildContext context,
    required WalletProvider wallet,
    required String sendAmount,
    required String cleanedDestinationAddress,
    required String speedDropdownValue}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransactionConfirmationPage(
                wallet: wallet,
                amount: sendAmount,
                address: cleanedDestinationAddress,
                fee: speedDropdownValue,
              )));
}
