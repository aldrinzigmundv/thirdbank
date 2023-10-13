import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/services/routing.dart';

class AuthenticationQuestionPage extends StatefulWidget {
  const AuthenticationQuestionPage(
      {super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<AuthenticationQuestionPage> createState() =>
      _AuthenticationQuestionPageState();
}

class _AuthenticationQuestionPageState
    extends State<AuthenticationQuestionPage> {
  _AuthenticationQuestionPageState();

  late WalletProvider wallet;
  late StorageProvider storage;

  final AuthenticationProvider authentication = AuthenticationProvider();

  _addLocalAuth() async {
    await storage.write(key: "setupdone", value: "true");
    await storage.write(key: "lock", value: "true");
    if (context.mounted) {
      goToHomePage(context: context, wallet: wallet, storage: storage);
    }
  }

  _noLocalAuth() async {
    await storage.write(key: "setupdone", value: "true");
    await storage.write(key: "lock", value: "false");
    if (context.mounted) {
      goToHomePage(context: context, wallet: wallet, storage: storage);
    }
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
          "Authenication",
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
                    "Would you like to lock this app with your phone lock?",
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () => _addLocalAuth(),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        "Yes, fingeprint, PIN, etc.",
                        style: TextStyle(fontSize: 20.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () => _noLocalAuth(),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        "No, opt me out.",
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
