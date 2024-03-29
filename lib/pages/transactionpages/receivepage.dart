import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:thirdbank/services/wallet.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key, required this.wallet});

  final WalletProvider wallet;

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  _ReceivePageState();

  late WalletProvider wallet;

  _copyWalletAddressToClipboard() {
    Clipboard.setData(ClipboardData(text: wallet.walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Wallet address copied to clipboard."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    wallet = widget.wallet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellowAccent,
        centerTitle: true,
        title: const Text("Receive Bitcoin",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: GestureDetector(
        onTap: () => _copyWalletAddressToClipboard(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Text(
                    "Scan this QR Code or Tap It to Copy Your Bitcoin Wallet Address Below",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: QrImageView(
                    data: 'bitcoin:${wallet.walletAddress}',
                    version: QrVersions.auto,
                    size: 270.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    wallet.walletAddress,
                    style: const TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
