import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/services/routing.dart';

class GenerateMnemonicPage extends StatefulWidget {
  const GenerateMnemonicPage(
      {super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<GenerateMnemonicPage> createState() => _GenerateMnemonicPageState();
}

class _GenerateMnemonicPageState extends State<GenerateMnemonicPage> {
  _GenerateMnemonicPageState();

  late WalletProvider wallet;
  late StorageProvider storage;

  final AuthenticationProvider authentication = AuthenticationProvider();

  _regenarateMnemonic() {
    wallet.generateMnemonic();
  }

  _proceedWithCreatedMnemonic() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Creating Wallet..."),
      duration: Duration(seconds: 2),
    ));
    try {
      await wallet.createOrRestoreWallet(mnemonic: wallet.mnemonic);
      await storage.write(key: "mnemonic", value: wallet.mnemonic);
      wallet.mnemonic = "";
      await wallet.getNewAddress();
      await storage.write(key: "address", value: wallet.walletAddress);
      _evaluateNextPage();
    } catch (_) {
      _showFailedCreatingWalletError();
    }
  }

  _evaluateNextPage() async {
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

  _showFailedCreatingWalletError() {
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
    wallet.generateMnemonic();
    authentication.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Generated Passphrase",
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
                "Generated Passphrase",
                style: TextStyle(
                  fontSize: 26.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 18.0),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: wallet.mnemonic));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Passphrase copied to clipboard."),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Observer(
                  builder: (_) => Text(
                    wallet.mnemonic,
                    style: const TextStyle(
                      fontSize: 21.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Observer(
                builder: (_) => const Text(
                  "Please, keep this passphrase secure. It's the only way to recover your wallet in case you lose your device.",
                  style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton(
                onPressed: () => _proceedWithCreatedMnemonic(),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Text(
                      "Proceed with New Wallet",
                      style: TextStyle(fontSize: 21.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton(
                onPressed: () => _regenarateMnemonic(),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Text(
                      "Give Me Another Passphrase",
                      style: TextStyle(fontSize: 21.0),
                    )),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
