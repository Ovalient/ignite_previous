import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/registration/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin<MainPage> {
  int _index = 0;

  List<Widget> swiper = [
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp1.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp2.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp3.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
  ];

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RegistrationPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool("first_login") ?? false);

    if (!_seen) {
      await prefs.setBool("first_login", true);
      Navigator.push(context, _createRoute());
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메인")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("업데이트 소식",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: 3,
                controller: PageController(),
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  return swiper[index];
                },
              ),
            ),
            SizedBox(height: 10.0),
            Divider(thickness: 0.4, height: 1.0),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
