import 'package:flutter/material.dart';
import 'package:ignite/pages/auth_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class DashboardPage extends StatefulWidget {
  static const String id = "/dashboardPage";
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Dashboard Page'),
              SizedBox(height: 15.0),
              ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () async {
                    await signOut().then((result) {
                      Navigator.popAndPushNamed(context, AuthPage.id);
                    }).catchError((error) {
                      print('Sign Out Error: $error');
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
