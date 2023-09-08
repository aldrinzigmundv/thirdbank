import 'package:flutter/material.dart';

import 'package:thirdbank/services/storage.dart';
import 'package:thirdbank/services/wallet.dart';
import 'package:thirdbank/pages/home%20pages/walletpage.dart';
import 'package:thirdbank/pages/home pages/receive.dart';
import 'package:thirdbank/pages/home%20pages/donationpage.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.wallet, required this.storage});

  final WalletProvider wallet;
  final StorageProvider storage;

  @override
  State<Home> createState() => _Home(wallet, storage);
}

class _Home extends State<Home> {
  _Home(this.wallet, this.storage);

  late WalletProvider wallet;
  late StorageProvider storage;

  int _selectedIndex = 1;

  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const DonationPage(),
      WalletPage(
        wallet: wallet,
      ),
      ReceivePage(
        wallet: wallet,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Third Bank",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, //New
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.yellowAccent,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Donate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Receive',
            ),
          ]),
    );
  }
}
