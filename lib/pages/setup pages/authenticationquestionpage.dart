import 'package:flutter/material.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/authentication.dart';
import 'package:thirdbank/pages/home.dart';

class AuthenticationQuestionPage extends StatefulWidget {
  const AuthenticationQuestionPage(
      {super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<AuthenticationQuestionPage> createState() =>
      _AuthenticationQuestionPageState(wallet, storage);
}

class _AuthenticationQuestionPageState
    extends State<AuthenticationQuestionPage> {
  _AuthenticationQuestionPageState(this.wallet, this.storage);

  final WalletProvider wallet;
  final StorageProvider storage;

  final AuthenticationProvider authentication = AuthenticationProvider();

  addLocalAuth() async {
    await storage.write(key: "setupdone", value: "true");
    await storage.write(key: "lock", value: "true");
    goToHome();
  }

  noLocalAuth() async {
    await storage.write(key: "setupdone", value: "true");
    await storage.write(key: "lock", value: "false");
    goToHome();
  }

  goToHome () {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  wallet: wallet,
                  storage: storage,
                )),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
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
                  onPressed: () => addLocalAuth(),
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
                  onPressed: () => noLocalAuth(),
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
