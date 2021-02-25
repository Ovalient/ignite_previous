import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  static const String id = "/loginPage";
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'PLAY',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 54, fontWeight: FontWeight.w900)),
                            TextSpan(
                                text: '.\n',
                                style: GoogleFonts.robotoCondensed(
                                    color: Colors.redAccent,
                                    fontSize: 54,
                                    fontWeight: FontWeight.w900)),
                            TextSpan(
                                text: 'TOGETHER',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 54, fontWeight: FontWeight.w900)),
                            TextSpan(
                                text: '.',
                                style: GoogleFonts.robotoCondensed(
                                    color: Colors.redAccent,
                                    fontSize: 54,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildTextField(
                          _nameController, Icons.account_circle, 'Username'),
                      SizedBox(height: 20),
                      _buildTextField(
                          _passwordController, Icons.lock, 'Password'),
                      SizedBox(height: 30),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {},
                        color: Theme.of(context).accentColor,
                        child: Text('Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          //Here goes the logic for Google SignIn discussed in the next section
                        },
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.google),
                            SizedBox(width: 10),
                            Text('Sign-in using Google',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: new Border(bottom: new BorderSide(color: Colors.redAccent))),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            fillColor: Colors.redAccent,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            icon: Icon(
              icon,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }

  // _signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  //   final FirebaseUser user =
  //       (await firebaseAuth.signInWithCredential(credential)).user;
  // }
}
