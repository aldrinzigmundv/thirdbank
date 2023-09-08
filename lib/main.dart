import 'package:flutter/material.dart';

import 'package:thirdbank/pages/loadingpage.dart';

void main() => runApp(
  MaterialApp(
    title: "Third Bank",
    initialRoute: '/',
    routes: {
      '/': (context) => const LoadingPage(),
    },
));