import 'package:flutter/material.dart';
import 'package:ignite/pages/dashboard_page.dart';
import 'package:ignite/pages/sign_up_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class SignInPage extends StatefulWidget {
  static const String id = "/signInPage";
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  bool _isLoggingIn = false;

  String loginStatus;
  Color loginStringColor = Colors.green;

  void signInRequest() async {
    if (_emailController.text != null && _passwordController.text != null) {
      await signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((result) {
        if (result) {
          print(result);
          setState(() {
            loginStatus = 'You have successfully signed in';
            loginStringColor = Colors.green;
          });
          Navigator.popAndPushNamed(context, DashboardPage.id);
        }
      }).catchError((error) {
        print('Login Error: $error');
        setState(() {
          loginStatus = 'Error occured while logging in';
          loginStringColor = Colors.red;
        });
      });
    } else {
      setState(() {
        loginStatus = 'Please enter email & password';
        loginStringColor = Colors.red;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.text = null;
    _passwordController = TextEditingController();
    _passwordController.text = null;
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'PLAY',
                                style: TextStyle(
                                    fontFamily: 'BarlowSemiCondensed',
                                    fontSize: 54.0)),
                            TextSpan(
                                text: '.\n',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'BarlowSemiCondensed',
                                    fontSize: 54.0)),
                            TextSpan(
                                text: 'TOGETHER',
                                style: TextStyle(
                                    fontFamily: 'BarlowSemiCondensed',
                                    fontSize: 54.0)),
                            TextSpan(
                                text: '.',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'BarlowSemiCondensed',
                                    fontSize: 54.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: new Border(
                                bottom:
                                    new BorderSide(color: Colors.redAccent))),
                        child: TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                              fillColor: Colors.redAccent,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _isEditingEmail = true;
                            });
                          },
                          onSubmitted: (value) {
                            _emailFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: new Border(
                                bottom:
                                    new BorderSide(color: Colors.redAccent))),
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.redAccent,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Password',
                              icon: Icon(
                                Icons.lock,
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _isEditingPassword = true;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _isLoggingIn = true;
                            });
                            signInRequest();
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      loginStatus != null
                          ? Center(
                              child: Text(loginStatus,
                                  style: TextStyle(
                                      color: loginStringColor, fontSize: 14.0)))
                          : Container(),
                      SizedBox(height: 15),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () async {
                          setState(() {
                            _isLoggingIn = true;
                            _emailFocusNode.unfocus();
                            _passwordFocusNode.unfocus();
                          });
                          signInRequest();
                        },
                        color: Theme.of(context).accentColor,
                        child: Text('Sign In',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).accentColor)),
                        child: MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpPage.id);
                          },
                          color: Colors.white,
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16)),
                          textColor: Colors.white,
                        ),
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
}