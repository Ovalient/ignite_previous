import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  static const String id = "/introPage";
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text('Intro Page')),
      ),
    );
  }
}
