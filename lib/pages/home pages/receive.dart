import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:thirdbank/services/wallet.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key, required this.wallet});

  final WalletProvider wallet;

  @override
  State<ReceivePage> createState() => _ReceivePageState(wallet);
}

class _ReceivePageState extends State<ReceivePage> {
  _ReceivePageState(this.wallet);

  final WalletProvider wallet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: wallet.walletAddress));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Wallet address copied to clipboard."),
          duration: Duration(seconds: 2),
        ));
      },
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
    );
  }
}
