import 'package:flutter/material.dart';
import 'package:ignite/pages/auth_page.dart';
import 'package:ignite/pages/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = "/homePage";
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.popAndPushNamed(context, AuthPage.id);
    } else {
      await prefs.setBool('seen', true);
      Navigator.popAndPushNamed(context, IntroPage.id);
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text('Home Page')),
      ),
    );
  }
}
