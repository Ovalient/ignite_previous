import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/utils/firebase_provider.dart';
import 'package:ignite/widgets/dialogs.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "/signUpPage";
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;

  FocusNode _usernameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confirmFocusNode;

  bool _isEditingUsername = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;
  bool _isEditingConfirm = false;

  bool _isUsernameExists = true;
  bool _isEmailExists = true;

  String signupStatus;
  Color signupStringColor = Colors.green;

  _checkUsernameExists(String name) async {
    final firestore = FirebaseFirestore.instance;
    final result = await firestore
        .collection("user")
        .where("username", isEqualTo: name)
        .limit(1)
        .get();

    List<QueryDocumentSnapshot> documents = result.docs;
    if (documents.length > 0)
      _isUsernameExists = true;
    else
      _isUsernameExists = false;
  }

  _checkEmailExists(String email) async {
    final firestore = FirebaseFirestore.instance;
    final result = await firestore
        .collection("user")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    List<QueryDocumentSnapshot> documents = result.docs;
    if (documents.length > 0)
      _isEmailExists = true;
    else
      _isEmailExists = false;
  }

  String _validateUsername(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Username can\'t be empty";
      } else if (!value.contains(RegExp(r"^[A-Za-z]+$"))) {
        return "Enter a correct username";
      } else if (_isUsernameExists) {
        return "Username is already exists";
      }
    }
    return null;
  }

  String _validateEmail(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Email can\'t be empty";
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-_]+\.[a-zA-Z]+"))) {
        return "Enter a correct email address";
      } else if (_isEmailExists) {
        return "Email is already exists";
      }
    }
    return null;
  }

  String _validatePassword(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Password can\'t be empty";
      } else if (value.length < 6) {
        return "Length of password should be greater than 6";
      }
    }
    return null;
  }

  String _validateConfirm(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Password can\'t be empty";
      } else if (value.length < 6) {
        return "Length of password should be greater than 6";
      } else if (value != _passwordController.text.trim()) {
        return "Password is not matched";
      }
    }
    return null;
  }

  void signUpRequest() async {
    if (_validateUsername(_usernameController.text) == null &&
        _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null &&
        _validateConfirm(_confirmController.text) == null) {
      await signUp(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((result) async {
        if (result == null) {
          setState(() {
            signupStatus = "?????? ????????? ?????????????????????";
            signupStringColor = Colors.green;
          });
          signUpCompletionDialog(context);
        } else {
          signupStatus = result;
          signupStringColor = Colors.red;
        }
      });
    } else {
      setState(() {
        signupStatus = "Please enter every text field";
        signupStringColor = Colors.red;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _usernameController.text = null;
    _emailController.text = null;
    _passwordController.text = null;
    _confirmController.text = null;
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Theme.of(context).accentColor,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sign Up",
                style: TextStyle(color: Theme.of(context).accentColor)),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_left,
                  color: Theme.of(context).accentColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.redAccent))),
                    child: TextField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        fillColor: Colors.redAccent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: "Username",
                        icon: Icon(
                          Icons.person,
                        ),
                        // prefix: Icon(icon),
                        border: InputBorder.none,
                        errorText: _isEditingUsername
                            ? _validateUsername(_usernameController.text)
                            : null,
                        errorStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                        suffixIcon:
                            (_validateUsername(_usernameController.text) !=
                                    null)
                                ? Icon(Icons.clear, color: Colors.red[900])
                                : Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) async {
                        await _checkUsernameExists(value);
                        setState(() {
                          _isEditingUsername = true;
                        });
                      },
                      onSubmitted: (value) {
                        _usernameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.redAccent))),
                    child: TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.redAccent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: "Email",
                        icon: Icon(
                          Icons.email,
                        ),
                        // prefix: Icon(icon),
                        border: InputBorder.none,
                        errorText: _isEditingEmail
                            ? _validateEmail(_emailController.text)
                            : null,
                        errorStyle:
                            TextStyle(fontSize: 12, color: Colors.redAccent),
                        suffixIcon:
                            (_validateEmail(_emailController.text) != null)
                                ? Icon(Icons.clear, color: Colors.red[900])
                                : Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) async {
                        await _checkEmailExists(value);
                        setState(() {
                          _isEditingEmail = true;
                        });
                      },
                      onSubmitted: (value) {
                        _emailFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.redAccent))),
                    child: TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.redAccent,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: "Password",
                          icon: Icon(
                            Icons.lock,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none,
                          errorText: _isEditingPassword
                              ? _validatePassword(_passwordController.text)
                              : null,
                          errorStyle:
                              TextStyle(fontSize: 12, color: Colors.redAccent),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isEditingPassword = true;
                          });
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_confirmFocusNode);
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.redAccent))),
                    child: TextField(
                        controller: _confirmController,
                        focusNode: _confirmFocusNode,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.redAccent,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: "Confirm Password",
                          icon: Icon(
                            Icons.lock,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none,
                          errorText: _isEditingConfirm
                              ? _validateConfirm(_confirmController.text)
                              : null,
                          errorStyle:
                              TextStyle(fontSize: 12, color: Colors.redAccent),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isEditingConfirm = true;
                          });
                        },
                        onSubmitted: (value) {
                          _confirmFocusNode.unfocus();
                          signUpRequest();
                        }),
                  ),
                  SizedBox(height: 15.0),
                  signupStatus != null
                      ? Center(
                          child: Text(signupStatus,
                              style: TextStyle(
                                  color: signupStringColor, fontSize: 14.0)))
                      : Container(),
                  SizedBox(height: 15.0),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: (_validateUsername(_usernameController.text) ==
                                null &&
                            _validateEmail(_emailController.text) == null &&
                            _validatePassword(_passwordController.text) ==
                                null &&
                            _validateConfirm(_confirmController.text) == null)
                        ? () {
                            setState(() {
                              _usernameFocusNode.unfocus();
                              _emailFocusNode.unfocus();
                              _passwordFocusNode.unfocus();
                              _confirmFocusNode.unfocus();
                            });
                            signUpRequest();
                          }
                        : null,
                    color: Theme.of(context).accentColor,
                    disabledColor: Colors.grey[350],
                    child: Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
