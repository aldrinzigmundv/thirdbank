import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/services/routing.dart';

class RestoreMnemonicPage extends StatefulWidget {
  const RestoreMnemonicPage(
      {super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<RestoreMnemonicPage> createState() => _RestoreMnemonicPageState();
}

class _RestoreMnemonicPageState extends State<RestoreMnemonicPage> {
  _RestoreMnemonicPageState();

  late WalletProvider wallet;
  late StorageProvider storage;

  final AuthenticationProvider authentication = AuthenticationProvider();

  final TextEditingController _mnemonic = TextEditingController();

  bool checkMnemonicLength(String input) {
    final List<String> words = input.split(' ');
    final int wordCount = words.length;

    return wordCount == 12 || wordCount == 18 || wordCount == 24;
  }

  restoreOldWallet() async {
    if (checkMnemonicLength(_mnemonic.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Restoring..."),
        duration: Duration(seconds: 2),
      ));
      try {
        await wallet.createOrRestoreWallet(mnemonic: _mnemonic.text);
        await storage.write(key: "mnemonic", value: _mnemonic.text);
        wallet.mnemonic = "";
        await wallet.getNewAddress();
        await storage.write(key: "address", value: wallet.walletAddress);
        evaluateNextPage();
      } catch (_) {
        showFailedRestoringWalletError();
      }
    } else {
      showBadPassphraseError();
    }
  }

  evaluateNextPage() async {
    final localAuthAvailable =
        await authentication.checkAuthenticationAvailability();
    if (!localAuthAvailable) {
      await storage.write(key: "setupdone", value: "true");
      await storage.write(key: "lock", value: "false");
      if (context.mounted) {
        goToHomePage(context: context, wallet: wallet, storage: storage);
      }
    } else {
      if (context.mounted) {
        goToAuthenticationQuestionPage(
            context: context, wallet: wallet, storage: storage);
      }
    }
  }

  showFailedRestoringWalletError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Failed restoring wallet. Please, check passphrase or your internet connection."),
      duration: Duration(seconds: 2),
    ));
  }

  showBadPassphraseError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Failed restoring wallet. Please, check passphrase."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    wallet = widget.wallet;
    storage = widget.storage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Restore an Old Wallet",
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
                const Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Text(
                    "Enter Passphrase",
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: TextField(
                    minLines: 5,
                    maxLines: 5,
                    controller: _mnemonic,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Passphrases can either be 12, 18 or 24 words'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ElevatedButton(
                    onPressed: () => restoreOldWallet(),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellowAccent),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Restore Old Wallet",
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
