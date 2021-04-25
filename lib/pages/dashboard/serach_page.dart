import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ignite/pages/registration/registration_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Map _images = Map<String, Image>();
  bool _imageLoaded = false;

  String _boardId;
  bool _isSelected = false;

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RegistrationPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Future<Widget> getBoardList(String id) async {
  //   await firestore.collection("board").doc(id).collection("content").get().then((snapshot) {
  //     snapshot.docs.
  //   })
  // }

  Future preloadImages() async {
    await firestore.collection("gamelist").get().then((snapshots) {
      snapshots.docs.forEach((element) {
        _images.putIfAbsent(
            element.data()["id"],
            () => Image.asset(
                "assets/images/game_icons/${element.data()["id"]}.png"));
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    preloadImages().then((_) {
      _images.forEach((key, value) async {
        await precacheImage(value.image, context).then((_) {
          setState(() {});
        });
        _imageLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Scaffold registBody() => Scaffold(
          appBar: AppBar(title: Text("동료 찾기")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("처음 오셨나요?\n\'게임 등록\' 버튼을 눌러 게임을 등록해주세요"),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: () {
                      Navigator.push(context, _createRoute());
                    },
                    color: Theme.of(context).accentColor,
                    child: Text("게임 등록",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );

    Scaffold searchBody(AsyncSnapshot<dynamic> snapshot) => Scaffold(
          appBar: AppBar(
              title: Text("동료 찾기"),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                    height: 60.0,
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _boardId = snapshot.data.docs[index].id;
                                _isSelected = true;
                              });
                            },
                            child: _images[snapshot.data.docs[index].id]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 10.0);
                      },
                    ),
                  ))),
          body: SingleChildScrollView(
            child: _boardId != null && _isSelected
                ? StreamBuilder(
                    stream: firestore
                        .collection("board")
                        .doc(_boardId)
                        .collection("content")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: CircularProgressIndicator()));

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: InkWell(
                                onTap: () {},
                                child: ListTile(
                                    title: Text(
                                        snapshot.data.docs[index]
                                            .data()["title"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                            );
                          });
                    })
                : Center(
                    child: Text("동료를 찾을 게임을 선택해주세요."),
                  ),
          ),
        );

    return StreamBuilder(
      stream: firestore
          .collection("user")
          .doc(getUser().uid)
          .collection("accounts")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot == null)
          return registBody();
        else if (snapshot != null && _imageLoaded) return searchBody(snapshot);

        return Scaffold(
          appBar: AppBar(title: Text("동료 찾기")),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
