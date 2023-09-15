import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/formatting.dart';
import 'package:thirdbank/services/routing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  late WalletProvider wallet;
  late StorageProvider storage;

  FormattingProvider format = FormattingProvider();

  String _transactionAreaMessage = "Your transactions will appear here.";

  refreshWallet() async {
    try {
      await wallet.syncWallet();
      await wallet.getBlockchainHeight();
      await wallet.getBalance();
      await wallet.getTransactions();
      if (wallet.transactions.isNotEmpty) {
        setState(() {
          _transactionAreaMessage = 'Tap on a transaction to get more info.';
        });
      }
    } catch (_) {
      showFailedRefreshingWalletError();
    }
  }

  showTransactionInfo(int index, int blockHeight, int finalFee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Additional Info'),
          content: Text(
              'Fee: ${format.formatFee(finalFee)}\n\nConfirmations: ${format.formatConfirmations(blockchainHeight: wallet.blockchainHeight, transactionHeight: blockHeight)}\n\nTransaction ID: ${wallet.transactions[index].txid}'),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: wallet.transactions[index].txid));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Wallet address copied to clipboard."),
                  duration: Duration(seconds: 2),
                ));
              },
              child: const Text('Copy Transaction ID'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  showFailedRefreshingWalletError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:
          Text("Something went wrong. Please, check your internet connection."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    wallet = widget.wallet;
    storage = widget.storage;
    refreshWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.yellowAccent,
          centerTitle: true,
          title: const Text("Third Bank",
              style: TextStyle(
                color: Colors.black,
              ))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 18.0, 9.0, 9.0),
              child: Card(
                color: Colors.yellow[300],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 36.0, 9.0, 36.0),
                  child: Observer(
                    builder: (_) => Text(
                      wallet.balanceHolder,
                      style: const TextStyle(fontSize: 27.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton(
                onPressed: () => refreshWallet(),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Refresh Wallet",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton(
                onPressed: () =>
                    goToSendBitcoinPage(context: context, wallet: wallet),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Send Bitcoin",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton(
                onPressed: () =>
                    goToReceivePage(context: context, wallet: wallet),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Receive Bitcoin",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            ),
            const SizedBox(
              height: 9.0,
            ),
            const Padding(
                padding: EdgeInsets.all(9.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Transactions',
                      style: TextStyle(fontSize: 24.0),
                    ))),
            Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  _transactionAreaMessage,
                  style: const TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                )),
            Observer(
              builder: (_) => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: wallet.transactions.length,
                  itemBuilder: (context, index) {
                    String confirmationTime = format.formatTimeStamp(
                        wallet.transactions[index].confirmationTime?.timestamp);
                    int blockHeight = format.formatBlockHeight(
                        wallet.transactions[index].confirmationTime?.height);
                    if (wallet.transactions[index].sent == 0) {
                      int finalFee =
                          format.getFee(wallet.transactions[index]?.fee);
                      return GestureDetector(
                        onTap: () =>
                            showTransactionInfo(index, blockHeight, finalFee),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 9.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Received ${wallet.transactions[index].received} sats',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      confirmationTime,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    } else {
                      int finalFee =
                          format.getFee(wallet.transactions[index]?.fee);
                      return GestureDetector(
                        onTap: () =>
                            showTransactionInfo(index, blockHeight, finalFee),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 9.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sent ${wallet.transactions[index].sent - (finalFee + wallet.transactions[index].received)} sats',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      confirmationTime,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
