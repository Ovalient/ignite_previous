import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/registration/profile_search/league_of_legends.dart';

final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class SelectGamePage extends StatefulWidget {
  static const String id = "/dashboardPage/selectGamePage";
  SelectGamePage({Key key}) : super(key: key);

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('새 게임 등록')),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamBuilder(
              stream:
                  firestore.collection('gamelist').orderBy('name').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularProgressIndicator()));

                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return snapshot.data.docs[index].data()['imageLink'] == null
                        ? Container()
                        : Card(
                            elevation: 0.4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(0.0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    _createRoute(ProfileSearchPage(
                                        gameName: snapshot.data.docs[index]
                                            .data()['name'])));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.network(
                                      snapshot.data.docs[index]
                                          .data()['imageLink'],
                                      fit: BoxFit.contain),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Divider(height: 10.0)),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      snapshot.data.docs[index].data()['name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileSearchPage extends StatefulWidget {
  static const String id = "/dashboardPage/searchProfile";
  final String gameName;

  ProfileSearchPage({this.gameName, Key key}) : super(key: key);

  @override
  _ProfileSearchPageState createState() => _ProfileSearchPageState();
}

class _ProfileSearchPageState extends State<ProfileSearchPage> {
  Widget setLayout(String gameName) {
    switch (gameName) {
      case 'League of Legends':
        return LeagueOfLegendsProfile();
        break;
      default:
        return Center(child: Text(gameName));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('프로필 검색')),
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: setLayout(widget.gameName),
          ),
        ),
      ),
    );
  }
}
