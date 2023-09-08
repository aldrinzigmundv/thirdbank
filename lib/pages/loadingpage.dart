import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/pages/home.dart';
import 'package:thirdbank/pages/setup%20pages/mnemonicquestionpage.dart';

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
        goToMnemonicQuestionPage();
      }
    });
  }

  void startWallet() async {
    try {
    wallet.mnemonic = await storage.read(key: "mnemonic");
    wallet.walletAddress = await storage.read(key: "address");
    await wallet.createOrRestoreWallet(
        mnemonic: wallet.mnemonic, path: "m/84'/0'/0'");
    wallet.mnemonic = "";
    wallet.getBlockchainHeight();
    goToHome();
    } on Exception catch (_) {
      setState(() {
      _loadingpagetext =
        "Something went wrong. Either phone authentication failed or bad internet connection...";
    });
    }
  }

  goToHome () {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  wallet: wallet,
                  storage: storage,
                )));
  }

  void goToMnemonicQuestionPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MnemonicQuestionPage(
                  wallet: wallet,
                  storage: storage,
                )));
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
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(_loadingpagetext, style: const TextStyle(fontSize: 27.0,), textAlign: TextAlign.center,),
          )
        ]),
      ),
    );
  }
}
