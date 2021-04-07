import 'package:flutter/material.dart';

class MyInfoPage extends StatefulWidget {
  static const String id = "/myPage/myInfoPage";
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(title: Text("내 정보")), body: Text("내 정보")),
    );
  }
}
