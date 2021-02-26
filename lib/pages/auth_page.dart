import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/home_page.dart';
import 'package:ignite/pages/login_page.dart';
import 'package:ignite/utils/firebase_provider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  static const String id = "/authPage";
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseProvider>(
          create: (_) => FirebaseProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseProvider>().authState,
        ),
      ],
      child: Authenticate(),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      //Means that the user is logged in already and hence navigate to HomePage
      return HomePage();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return LoginPage();
  }
}
