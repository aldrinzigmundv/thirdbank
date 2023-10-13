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

  _sendBitcoin(BuildContext context) async {
    try {
      await esploraProvider.getFees();
      final finalFee = esploraProvider.getFee(format.formatSpeed(fee));
      await wallet.sendTx(
          addressStr: address, amount: int.parse(amount), fee: finalFee);
      if (context.mounted) {
        _showTransactionSentMessage(context);
        _goBackTwice(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  _showTransactionSentMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Transaction sent to blockchain."),
      duration: Duration(seconds: 2),
    ));
  }

  _goBackTwice(context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Failed sending Bitcoin. Please, check your balance or internet connection."),
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
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(padding: EdgeInsets.all(9.0), child: Text('Transaction Fee', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold))),
                        Padding(padding: const EdgeInsets.all(9.0), child: Text(fee, style: const TextStyle(fontSize: 21.0))),
                        const SizedBox(height: 18.0,),
                        const Padding(padding: EdgeInsets.all(9.0), child: Text('Amount to Send', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold))),
                        Padding(padding: const EdgeInsets.all(9.0), child: Text('$amount sats', style: const TextStyle(fontSize: 21.0))),
                        const SizedBox(height: 18.0,),
                        const Padding(padding: EdgeInsets.all(9.0), child: Text('Destination Address', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold))),
                        Padding(padding: const EdgeInsets.all(9.0), child: Text(address, style: const TextStyle(fontSize: 21.0))),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle),
          onPressed: () => _sendBitcoin(context),
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
