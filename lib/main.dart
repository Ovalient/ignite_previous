import 'package:flutter/material.dart';
import 'package:ignite/pages/intro_page.dart';
import 'package:ignite/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:ignite/pages/splash_page.dart';
import 'package:ignite/utils/theme.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays(
  //     [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ignite',
        theme: basicTheme,
        initialRoute: SplashPage.id,
        routes: {
          SplashPage.id: (context) => SplashPage(),
          IntroPage.id: (context) => IntroPage(),
          LoginPage.id: (context) => LoginPage(),
        });
  }
}
