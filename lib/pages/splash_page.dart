import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ignite/pages/intro_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = "/splashPage";
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),
        () => Navigator.popAndPushNamed(context, IntroPage.id));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFF0000),
        body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset('assets/icons/Ignite_Icon.png'))),
      ),
    );
  }
}
