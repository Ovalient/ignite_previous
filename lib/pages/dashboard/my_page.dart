import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/pages/my_pages/my_info_page.dart';
import 'package:local_auth/local_auth.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: "생체 정보로 인증해주세요",
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushNamed(context, MyInfoPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내 정보")),
      body: Center(
        child: Container(
          child: ListView(
            children: [
              InkWell(
                  onTap: () async {
                    if (await _isBiometricAvailable()) {
                      await _getListOfBiometricTypes();
                      await _authenticateUser();
                    }
                  },
                  child: ListTile(title: Text("내 정보"))),
              InkWell(onTap: () {}, child: ListTile(title: Text("공지사항"))),
              Divider(height: 8.0, thickness: 8.0),
              InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text("연결된 계정"),
                    subtitle: Text("현재 연동된 게임 계정을 수정하거나 삭제합니다"),
                  )),
              Divider(height: 8.0, thickness: 8.0),
              InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text("회원 탈퇴",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w500)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
