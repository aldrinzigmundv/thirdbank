import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/services/routing.dart';

class SendBitcoinPage extends StatefulWidget {
  const SendBitcoinPage({super.key, required this.wallet});

  final WalletProvider wallet;

  @override
  State<SendBitcoinPage> createState() => _SendPage();
}

class _SendPage extends State<SendBitcoinPage> {
  _SendPage();

  late WalletProvider wallet;

  final TextEditingController _sendAmount = TextEditingController();
  final TextEditingController _destinationAddress = TextEditingController();

  String _scannedQRAddress = "";
  String _scanQRButtonText = "Scan Recipient's QR Code";

  String _speedDropdownValue = 'Moderate Fee (settles around 1 hour)';
  final List<String> _speeds = <String>[
    'Highest Fee (settles <10 minutes)',
    'Higher Fee (settles around 10 minutes)',
    'Moderate Fee (settles around 1 hour)',
    'Lower Fee (settles around 24 hours)',
    'Lowest Fee (settles around 7 days)',
  ];

  _scanQRCode() async {
    ScanResult result;
    try {
      result = await BarcodeScanner.scan();
      _scannedQRAddress = result.rawContent;
      setState(() {
        _scanQRButtonText = "Rescan Recipient's QR Code";
        _destinationAddress.text = _cleanAddress(result.rawContent);
      });
    } catch (_) {
      _showQRScannerError();
    }
  }

  _checkRequiredFields() async {
    if (_sendAmount.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Amount and Bitcoin address required."),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
    if (_scannedQRAddress == "" && _destinationAddress.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Amount and Bitcoin address required."),
        duration: Duration(seconds: 2),
      ));
      return false;
    } else {
      return true;
    }
  }

  String _cleanAddress(String address) {
    if (address.startsWith('bitcoin:')) {
      address = address.substring('bitcoin:'.length);
    }
    int questionMarkIndex = address.indexOf('?');
    if (questionMarkIndex != -1) {
      address = address.substring(0, questionMarkIndex);
    }
    return address;
  }

  _processInputs() async {
    if (await _checkRequiredFields()) {
      if (int.parse(_sendAmount.text) >= 5460) {
        String chosenAddress = '';
        if (_scannedQRAddress != "") {
          chosenAddress = _scannedQRAddress;
        } else {
          chosenAddress = _destinationAddress.text;
        }
        final cleanedDestinationAddress = _cleanAddress(chosenAddress);
        if (mounted) {
          goToTransactionConfirmationPage(
              context: context,
              wallet: wallet,
              sendAmount: _sendAmount.text,
              cleanedDestinationAddress: cleanedDestinationAddress,
              speedDropdownValue: _speedDropdownValue);
        }
      } else {
        _showMinimumAmountError();
      }
    }
  }

  _showQRScannerError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Failed to start QR scanner."),
      duration: Duration(seconds: 2),
    ));
  }

  _showMinimumAmountError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Minimum amount is 5460 sats."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    _sendAmount.dispose();
    _destinationAddress.dispose();
    super.dispose();
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
        centerTitle: true,
        title: const Text(
          "Send Bitcoin",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: DropdownMenu(
                width: MediaQuery.of(context).size.width - 18.0,
                initialSelection: _speedDropdownValue,
                dropdownMenuEntries: _speeds.map((String value) {
                  return DropdownMenuEntry(
                    value: value,
                    label: value,
                  );
                }).toList(),
                onSelected: (String? newValue) {
                  setState(() {
                    _speedDropdownValue = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 27.0,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _sendAmount,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9]+$'),
                  )
                ],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Bitcoin Amount in sats'),
              ),
            ),
            const SizedBox(
              height: 27.0,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: TextField(
                controller: _destinationAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Recipient\'s Bitcoin Address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () => _scanQRCode(),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellowAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                label: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _scanQRButtonText,
                      style: const TextStyle(fontSize: 20.0),
                    )),
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            const Padding(
              padding: EdgeInsets.all(9.0),
              child: Text(
                'Make sure to have a little extra on your wallet for the Bitcoin blockchain\'s transaction fee.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ElevatedButton(
          onPressed: () => _processInputs(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              foregroundColor: MaterialStateProperty.all(Colors.black)),
          child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Review Transaction",
                style: TextStyle(fontSize: 20.0),
              )),
        ),
      ),
    );
  }
}
