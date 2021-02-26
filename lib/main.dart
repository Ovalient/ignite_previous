import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/auth_page.dart';
import 'package:ignite/pages/home_page.dart';
import 'package:ignite/pages/intro_page.dart';
import 'package:ignite/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:ignite/utils/theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ignite',
      theme: basicTheme,
      initialRoute: HomePage.id,
      routes: {
        IntroPage.id: (context) => IntroPage(),
        LoginPage.id: (context) => LoginPage(),
        AuthPage.id: (context) => AuthPage(),
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
