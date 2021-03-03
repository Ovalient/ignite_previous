import 'package:flutter/material.dart';

emailVerificationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('이메일 인증'),
            content: Text('이메일 확인 후, 다시 로그인 하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    },
  );
}
