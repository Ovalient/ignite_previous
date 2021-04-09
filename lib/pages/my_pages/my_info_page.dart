import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignite/utils/firebase_provider.dart';

class MyInfoPage extends StatefulWidget {
  static const String id = "/myPage/myInfoPage";
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final firestore = FirebaseFirestore.instance;

  List userInfo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("${getUser().displayName}님의 정보")),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: ListView(
            children: [
              CircleAvatar(
                radius: 80.0,
              ),
              SizedBox(height: 20.0),
              ListTile(
                  title: Text("이메일",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text(getUser().email)),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              ListTile(
                  title:
                      Text("이름", style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text(getUser().displayName)),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
