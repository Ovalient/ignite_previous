import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/dashboard_page.dart';
import 'package:ignite/pages/auth_page.dart';
import 'package:ignite/pages/intro_page.dart';
import 'package:ignite/pages/sign_in_page.dart';
import 'package:flutter/services.dart';
import 'package:ignite/pages/sign_up_page.dart';
import 'package:ignite/utils/theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
        initialRoute: DashboardPage.id,
        routes: {
          IntroPage.id: (context) => IntroPage(),
          AuthPage.id: (context) => AuthPage(),
          SignInPage.id: (context) => SignInPage(),
          SignUpPage.id: (context) => SignUpPage(),
          DashboardPage.id: (context) => DashboardPage(),
        });
  }
}
