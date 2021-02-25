import 'package:flutter/material.dart';
import 'package:ignite/assets/theme.dart';
import 'package:ignite/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ignite',
      theme: basicTheme,
      home: LoginPage(),
    );
  }
}
