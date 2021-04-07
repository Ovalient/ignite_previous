import 'package:flutter/material.dart';
import 'package:ignite/pages/sign_in_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      body: Center(
        child: Container(
          child: ListView(
            children: [
              InkWell(onTap: () {}, child: ListTile(title: Text('내 정보'))),
              InkWell(onTap: () {}, child: ListTile(title: Text('공지사항'))),
              Divider(height: 8.0, thickness: 8.0),
              InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text('연결된 계정'),
                    subtitle: Text('현재 연동된 게임 계정을 수정하거나 삭제합니다.'),
                  )),
              Divider(height: 8.0, thickness: 8.0),
              InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text('회원 탈퇴',
                        style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
