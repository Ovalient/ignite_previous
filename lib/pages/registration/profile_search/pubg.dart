import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ignite/model.dart';
import 'package:ignite/pages/dashboard_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class PUBGProfile extends StatefulWidget {
  PUBGProfile({Key key}) : super(key: key);

  @override
  _PUBGProfileState createState() => _PUBGProfileState();
}

class _PUBGProfileState extends State<PUBGProfile>
    with SingleTickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;

  AnimationController _animationController;
  Animation _animation;

  TextEditingController _textController;
  FocusNode _textFocusNode;
  bool _isEditingText = false;

  PUBGUser pubgUser;
  bool _searching = false;

  String _server;

  String _validateText(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Username can\'t be empty";
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animation.addListener(() => setState(() {}));

    _textController = TextEditingController();
    _textController.text = null;
    _textFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton(
              value: _server,
              onChanged: (value) {
                setState(() {
                  _server = value;
                });
              },
              items: ['Steam', 'Kakao'].map<DropdownMenuItem>((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              hint: Text("서버"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(color: Colors.redAccent))),
              child: TextField(
                controller: _textController,
                focusNode: _textFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                    fillColor: Colors.redAccent,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Username",
                    icon: Icon(
                      Icons.person,
                    ),
                    border: InputBorder.none,
                    errorText: _isEditingText
                        ? _validateText(_textController.text)
                        : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        _animationController.forward();
                        // if (_validateText(_textController.text) == null) {
                        //   pubgUser = await getUserName(_textController.text);
                        //   setState(() {
                        //     _searching = false;
                        //   });
                        //   _animationController.forward();
                        //   print(pubgUser.toString());
                        // }
                      },
                    )),
                onChanged: (value) {
                  setState(() {
                    _isEditingText = true;
                  });
                },
                onSubmitted: (value) async {
                  _animationController.forward();
                  // if (_validateText(_textController.text) == null) {
                  //   pubgUser = await getUserName(_textController.text);
                  //   setState(() {
                  //     _searching = false;
                  //   });
                  //   _animationController.forward();
                  //   print(pubgUser.toString());
                  // }
                },
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _animation,
              child: AnimatedOpacity(
                opacity: _searching ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInQuint,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: pubgUser == null
                      ? Text("사용자 정보가 없습니다")
                      : Card(
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("이 계정이 맞나요?"),
                                    content: ListTile(
                                      leading: CircleAvatar(
                                          child: Text("temp",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))),
                                      title: Text("temp",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text("temp"),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () async {
                                          // await addSummonerData();
                                        },
                                        child: Text("네"),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("아니요"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Text("temp",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              title: Text("temp",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("temp"),
                            ),
                          ),
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
