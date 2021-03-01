import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseProvider {
//   final FirebaseAuth _auth; // Firebase 인증 플러그인의 인스턴스
//   FirebaseProvider(this._auth);

//   Stream<User> get authState => _auth.idTokenChanges();

//   getUser() {
//     User user = _auth.currentUser;
//     return user;
//   }

//   // 이메일/비밀번호로 Firebase에 회원가입
//   Future<bool> signUp({String email, String password}) async {
//     bool flag = false;

//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       if (userCredential.user != null) {
//         return flag = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return flag;
//   }

//   // 이메일/비밀번호로 Firebase에 로그인
//   Future<bool> signIn({String email, String password}) async {
//     bool flag = false;

//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (userCredential.user != null) {
//         return flag = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return flag;
//   }

//   // Firebase로부터 로그아웃
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 영어로 전송 시도
//   sendPasswordResetEmailByEnglish() async {
//     await _auth.setLanguageCode("en");
//     sendPasswordResetEmail();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
//   sendPasswordResetEmailByKorean() async {
//     await _auth.setLanguageCode("ko");
//     sendPasswordResetEmail();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 전송
//   sendPasswordResetEmail() async {
//     User user = getUser();
//     _auth.sendPasswordResetEmail(email: user.email);
//   }

//   // Firebase로부터 회원 탈퇴
//   withdrawalAccount() async {
//     User user = getUser();
//     await user.delete();
//   }
// }

final FirebaseAuth _auth = FirebaseAuth.instance;

String _uid;
String _email;

User getUser() {
  User user = _auth.currentUser;
  return user;
}

// 이메일/비밀번호로 Firebase에 회원가입
Future<bool> signUp({String email, String password}) async {
  bool flag = false;

  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      _uid = userCredential.user.uid;
      _email = userCredential.user.email;
      return flag = true;
    }
  } catch (e) {
    print(e);
  }
  return flag;
}

// 이메일/비밀번호로 Firebase에 로그인
Future<bool> signIn({String email, String password}) async {
  bool flag = false;

  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      _uid = userCredential.user.uid;
      _email = userCredential.user.email;
      return flag = true;
    }
  } catch (e) {
    print(e);
  }
  return flag;
}

// Firebase로부터 로그아웃
Future<void> signOut() async {
  await _auth.signOut();
}