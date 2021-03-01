import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "/signUpPage";
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
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
                                  text: 'JOIN',
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
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: new Border(
                                  bottom:
                                      new BorderSide(color: Colors.redAccent))),
                          child: TextField(
                            // controller: _emailController,
                            // focusNode: _emailFocusNode,
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
                            // controller: _passwordController,
                            // focusNode: _passwordFocusNode,
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
                            // controller: _emailController,
                            // focusNode: _emailFocusNode,
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
                            // controller: _emailController,
                            // focusNode: _emailFocusNode,
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
                          ),
                        ),
                        SizedBox(height: 30.0),
                        MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: () {},
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
                            onPressed: () {},
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
      ),
    );
  }
}
