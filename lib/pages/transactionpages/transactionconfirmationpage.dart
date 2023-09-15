import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/formatting.dart';
import 'package:thirdbank/services/esplora.dart';

class TransactionConfirmationPage extends StatelessWidget {
  TransactionConfirmationPage(
      {super.key,
      required this.wallet,
      required this.amount,
      required this.address,
      required this.fee});

  final WalletProvider wallet;
  final format = FormattingProvider();
  final esploraProvider = EsploraProvider();

  final String amount;
  final String address;
  final String fee;

  sendBitcoin(BuildContext context) async {
    try {
      await esploraProvider.getFees();
      final finalFee = esploraProvider.getFee(format.formatSpeed(fee));
      wallet.sendTx(
          addressStr: address, amount: int.parse(amount), fee: finalFee);
      if (context.mounted) {
        showTransactionSentMessage(context);
        goBackTwice(context);
      }
    } catch (_) {
      if (context.mounted) {
        showError(context);
      }
    }
  }

  showTransactionSentMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Transaction sent to blockchain."),
      duration: Duration(seconds: 2),
    ));
  }

  goBackTwice(context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Failed sending Bitcoin. Please, check your internet connection or balance."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    esploraProvider.getFees();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Confirm Transaction',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Transaction Fee',
                  style: TextStyle(fontSize: 19.9),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 18.0, 9.0, 18.0),
                    child: Text(
                      fee,
                      style: const TextStyle(
                        fontSize: 19.9,
                        wordSpacing: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Amount To Send',
                  style: TextStyle(fontSize: 19.9),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 18.0, 9.0, 18.0),
                    child: Text(
                      '$amount sats',
                      style: const TextStyle(
                        fontSize: 19.9,
                        wordSpacing: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Receiving Address',
                  style: TextStyle(fontSize: 19.9),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 18.0, 9.0, 18.0),
                    child: Text(
                      address,
                      style: const TextStyle(fontSize: 19.9),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle),
          onPressed: () => sendBitcoin(context),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              foregroundColor: MaterialStateProperty.all(Colors.black)),
          label: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Confirm",
                style: TextStyle(fontSize: 20.0),
              )),
        ),
      ),
    );
  }
}
