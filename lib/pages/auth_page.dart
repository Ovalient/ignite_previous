import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/dashboard_page.dart';
import 'package:ignite/pages/intro_page.dart';
import 'package:ignite/pages/sign_in_page.dart';
import 'package:ignite/utils/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  static const String id = "/homePage";
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with AfterLayoutMixin<AuthPage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool("first_launch") ?? false);

    // await FlutterStatusbarcolor.setStatusBarColor(
    //     Theme.of(context).primaryColor);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    if (_seen) {
      print(getUser());
      if (getUser() != null && getUser().emailVerified) {
        Navigator.popAndPushNamed(context, DashboardPage.id);
      } else {
        Navigator.popAndPushNamed(context, SignInPage.id);
      }
    } else {
      await prefs.setBool("first_launch", true);
      Navigator.popAndPushNamed(context, IntroPage.id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
