import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class SelectGamePage extends StatefulWidget {
  static const String id = "/selectGamePage";
  SelectGamePage({Key key}) : super(key: key);

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  // Future<Map> getGameList() async {
  //   await firestore.collection('gamelist').get().then((snapshots) {
  //     snapshots.docs.forEach((element) {
  //       gameList.putIfAbsent(
  //           element.data()['name'], () => element.data()['imageLink']);
  //     });
  //   });
  //   // await firestore
  //   //     .collection('gamelist')
  //   //     .doc('KGE8Coe4skwptoPkHZ6X')
  //   //     .get()
  //   //     .then((snapshot) {
  //   //   List.from(snapshot.data()['gamelist']).forEach((element) async {
  //   //     String url =
  //   //         await storage.ref('GameIcons/$element.png').getDownloadURL();
  //   //     gameList.putIfAbsent(element, () => url);
  //   //   });
  //   // });

  //   return gameList;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('새 게임 등록하기')),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: StreamBuilder(
              stream: firestore.collection('gamelist').snapshots(),
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
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return snapshot.data.docs[index].data()['imageLink'] == null
                        ? Container()
                        : InkWell(
                            onTap: () {
                              print(snapshot.data.docs[index].data()['name']);
                            },
                            child: Ink(
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
                                      child: Divider()),
                                  Expanded(
                                    child: Text(
                                      snapshot.data.docs[index].data()['name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                    // Column(
                    //     children: [
                    //       Container(
                    //         color: Colors.black45,
                    //         child: Image.network(
                    //             snapshot.data.docs[index]
                    //                 .data()['imageLink'],
                    //             fit: BoxFit.contain),
                    //       ),
                    //       Text(snapshot.data.docs[index].data()['name']),
                    //     ],
                    //   );
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
