import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30.00, 0, 15.0),
            child: Text(
              "Donate Bitcoin to Support this App",
              style: TextStyle(fontSize: 21),
            ),
          ),
          GestureDetector(
              onTap: () {
                Clipboard.setData(const ClipboardData(
                    text: 'bc1qruus6vnxrww6pqac3hvg6vsepmqv8d66dwjm59'));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Wallet address copied to clipboard."),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: QrImageView(
                  data: 'bitcoin:bc1qruus6vnxrww6pqac3hvg6vsepmqv8d66dwjm59',
                  version: QrVersions.auto,
                  size: 270.0,
                ),
              )),
          const Padding(
            padding: EdgeInsets.all(9.0),
            child: Text(
              "Tap the QR Code to copy our Bitcoin Wallet Address to your Clipboard",
              style: TextStyle(fontSize: 18), textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}
