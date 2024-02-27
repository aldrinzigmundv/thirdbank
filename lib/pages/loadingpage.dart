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

  String _loadingpagetext = "Powered by aldrinzigmund.com";

  void _startup() async {
    Future.delayed(const Duration(seconds: 1), () async {
      await Future.wait([
        Future(() => storage.initialize()),
        Future(() => auth.initialize()),
      ]);
      if (await storage.read(key: "setupdone") == "true" &&
          await storage.read(key: "lock") == "true") {
        if (await auth.authenticate()) {
          _startWallet();
        } else {
          _displayError();
        }
      } else if (await storage.read(key: "setupdone") == "true" &&
          await storage.read(key: "lock") == "false") {
        _startWallet();
      } else {
        if (mounted) {
          goToMnemonicQuestionPage(
              context: context, wallet: wallet, storage: storage);
        }
      }
    });
  }

  void _startWallet() async {
    try {
      await Future.wait([
        Future(() => storage.read(key: "mnemonic")),
        Future(() => storage.read(key: "address")),
      ]).then((values) => {
            wallet.mnemonic = values[0],
            wallet.walletAddress = values[1],
          });

      await wallet.createOrRestoreWallet(mnemonic: wallet.mnemonic);
      wallet.mnemonic = "";
      await wallet.getBlockchainHeight();
      if (mounted) {
        goToHomePage(context: context, wallet: wallet, storage: storage);
      }
    } catch (_) {
      setState(() {
        _loadingpagetext =
            "Something went wrong. Either phone authentication failed or bad internet connection...";
      });
    }
  }

  _displayError() {
    setState(() {
      _loadingpagetext =
          "Something went wrong. Either phone authentication failed or bad internet connection...";
    });
  }

  @override
  void initState() {
    super.initState();
    _startup();
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
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
