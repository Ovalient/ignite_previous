import 'package:flutter/material.dart';
import 'package:ignite/pages/sign_in_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: ListView()
          // child: MaterialButton(
          //   elevation: 0,
          //   minWidth: double.maxFinite,
          //   height: 50,
          //   onPressed: () async {
          //     await signOut().then((result) {
          //       Navigator.popAndPushNamed(context, SignInPage.id);
          //     }).catchError((error) {
          //       print('Sign Out Error: $error');
          //     });
          //   },
          //   color: Theme.of(context).accentColor,
          //   child: Text('Sign Out',
          //       style: TextStyle(color: Colors.white, fontSize: 16)),
          //   textColor: Colors.white,
          // ),
        ),
      ),
    );
  }
}
