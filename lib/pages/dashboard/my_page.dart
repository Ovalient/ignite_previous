import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/pages/my_pages/my_info_page.dart';
import 'package:ignite/pages/sign_in_page.dart';
import 'package:ignite/utils/firebase_provider.dart';
import 'package:local_auth/auth_strings.dart';
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
          localizedReason: "생체 정보 혹은 PIN 번호를 입력하세요",
          androidAuthStrings:
              AndroidAuthMessages(signInTitle: "인증이 필요합니다", biometricHint: ""),
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
      appBar: AppBar(
        title: Text("내 정보"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              tooltip: "로그아웃",
              onPressed: () async {
                await signOut().then((result) {
                  Navigator.popAndPushNamed(context, SignInPage.id);
                }).catchError((error) {
                  print('Sign Out Error: $error');
                });
              })
        ],
      ),
      body: Container(
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
            Divider(height: 10.0, thickness: 10.0),
            InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text("계정 관리"),
                  subtitle: Text("게임 계정을 추가하거나 수정 및 삭제합니다",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                )),
            Divider(height: 10.0, thickness: 10.0),
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
    );
  }
}
