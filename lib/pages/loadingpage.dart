import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/services/routing.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final WalletProvider wallet = WalletProvider();
  final StorageProvider storage = StorageProvider();
  final AuthenticationProvider auth = AuthenticationProvider();

  String _loadingpagetext = "Please wait...";

  void startup() async {
    Future.delayed(const Duration(seconds: 1), () async {
      await storage.initialize();
      await auth.initialize();
      if (await storage.read(key: "setupdone") == "true" &&
          await storage.read(key: "lock") == "true") {
        if (await auth.authenticate()) {
          startWallet();
        } else {
          displayError();
        }
      } else if (await storage.read(key: "setupdone") == "true" &&
          await storage.read(key: "lock") == "false") {
        startWallet();
      } else {
        if (context.mounted) {
          goToMnemonicQuestionPage(
              context: context, wallet: wallet, storage: storage);
        }
      }
    });
  }

  void startWallet() async {
    try {
      wallet.mnemonic = await storage.read(key: "mnemonic");
      wallet.walletAddress = await storage.read(key: "address");
      await wallet.createOrRestoreWallet(mnemonic: wallet.mnemonic);
      wallet.mnemonic = "";
      wallet.getBlockchainHeight();
      if (context.mounted) {
        goToHomePage(context: context, wallet: wallet, storage: storage);
      }
    } catch (_) {
      setState(() {
        _loadingpagetext =
            "Something went wrong. Either phone authentication failed or bad internet connection...";
      });
    }
  }

  displayError() {
    setState(() {
      _loadingpagetext =
          "Something went wrong. Either phone authentication failed or bad internet connection...";
    });
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/icons/icon.png"),
          const Padding(
            padding: EdgeInsets.all(9.0),
            child: Text(
              'Third Bank',
              style: TextStyle(
                fontSize: 27.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 36.0),
            child: Text(
              _loadingpagetext,
              style: const TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          )
    );
  }
}
