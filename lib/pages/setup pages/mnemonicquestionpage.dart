import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/routing.dart';

class MnemonicQuestionPage extends StatelessWidget {
  const MnemonicQuestionPage(
      {super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wallet Setup",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "What would you like to do?",
                style: TextStyle(fontSize: 27.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () => goToGenerateMnemonicPage(
                      context: context, wallet: wallet, storage: storage),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Create a New Wallet",
                        style: TextStyle(fontSize: 20.0),
                      )),
                ),
              ),
              const SizedBox(height: 9.0),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () => goToRestoreMnemonicPage(
                      context: context, wallet: wallet, storage: storage),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Restore an Old Wallet",
                        style: TextStyle(fontSize: 20.0),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
