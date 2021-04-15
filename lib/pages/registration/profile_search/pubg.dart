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

  FocusNode _dropFocusNode;
  TextEditingController _textController;
  FocusNode _textFocusNode;
  bool _isEditingText = false;

  PUBGUser pubgUser;
  bool _searching = false;

  String _server;

  final headers = {
    "Authorization": "Bearer XXXX",
    "Accept": "application/vnd.api+json"
  };

  Future<String> getCurrentSeason() async {
    final url = "https://api.pubg.com/shards/steam/seasons";
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> seasonData = jsonDecode(response.body);
      List seasons = seasonData["data"];
      return seasons.last["id"];
    } else {
      return null;
    }
  }

  Future<PUBGUser> getUserName(String userName) async {
    final url =
        "https://api.pubg.com/shards/steam/players?filter[playerNames]=$userName";
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      List userInfo = userData["data"];
      return await getUserData(await getCurrentSeason(), userInfo);
    } else {
      return null;
    }
  }

  Future<PUBGUser> getUserData(String season, List userInfo) async {
    setState(() {
      _searching = true;
    });
    final server = _server == "Steam" ? "steam" : "kakao";
    final url =
        "https://api.pubg.com/shards/$server/players/${userInfo.first["id"]}/seasons/$season/ranked";
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      final Map<String, dynamic> rankData =
          userData["data"]["attributes"]["rankedGameModeStats"];
      print(rankData);
      if (rankData.isEmpty) {
        pubgUser = PUBGUser(
          name: userInfo.first["attributes"]["name"],
          accountId: userInfo.first["id"],
        );
      } else {
        if (rankData["solo"] != null) {
          if (rankData["squad"] != null) {
            pubgUser = PUBGUser(
              accountId: userInfo.first["id"],
              name: userInfo.first["attributes"]["name"],
              soloTier: rankData["solo"]["currentTier"]["tier"],
              soloRank: rankData["solo"]["currentTier"]["subTier"],
              soloPoints: rankData["solo"]["currentRankPoint"],
              squadTier: rankData["squad"]["currentTier"]["tier"],
              squadRank: rankData["squad"]["currentTier"]["subTier"],
              squadPoints: rankData["squad"]["currentRankPoint"],
            );
          } else {
            pubgUser = PUBGUser(
              accountId: userInfo.first["id"],
              name: userInfo.first["attributes"]["name"],
              soloTier: rankData["solo"]["currentTier"]["tier"],
              soloRank: rankData["solo"]["currentTier"]["subTier"],
              soloPoints: rankData["solo"]["currentRankPoint"],
            );
          }
        } else if (rankData["squad"] != null) {
          pubgUser = PUBGUser(
            accountId: userInfo.first["id"],
            name: userInfo.first["attributes"]["name"],
            squadTier: rankData["squad"]["currentTier"]["tier"],
            squadRank: rankData["squad"]["currentTier"]["subTier"],
            squadPoints: rankData["squad"]["currentRankPoint"],
          );
        }
      }
      return pubgUser;
    } else {
      return null;
    }
  }

  String _validateText(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "Username can\'t be empty";
      }
    }
    return null;
  }

  Widget getUserRankIcon() {
    switch (pubgUser.squadTier) {
      case "Bronze":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFFA46628),
            ));
        break;
      case "Silver":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFFC0C0C0),
            ));
        break;
      case "Gold":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFFFFD700),
            ));
        break;
      case "Platinum":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFF00CED1),
            ));
        break;
      case "Diamond":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFFF4BBFF),
            ));
        break;
      case "Master":
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.panorama_wide_angle_select,
              color: Color(0xFF8B0000),
            ));
        break;
      default:
        return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.panorama_wide_angle, color: Colors.grey));
        break;
    }
  }

  addUserData() async {
    await firestore
        .collection("user")
        .doc(getUser().uid)
        .collection("Playerunknown's Battlegrounds")
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        Navigator.pop(context);
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              var docId = value.docs.single.id;
              return AlertDialog(
                title: Text("어라?"),
                content: Text("이미 소환사 정보가 등록되어 있습니다\n\'네\'를 누르면 기존 정보를 덮어씌웁니다"),
                actions: [
                  MaterialButton(
                    onPressed: () async {
                      await firestore
                          .collection("user")
                          .doc(getUser().uid)
                          .collection("Playerunknown's Battlegrounds")
                          .doc(docId)
                          .delete();

                      await firestore
                          .collection("user")
                          .doc(getUser().uid)
                          .collection("Playerunknown's Battlegrounds")
                          .add({
                        "accountId": pubgUser.accountId,
                        "name": pubgUser.name,
                        "soloTier": pubgUser.soloTier,
                        "soloRank": pubgUser.soloRank,
                        "soloPoints": pubgUser.soloPoints,
                        "squadTier": pubgUser.squadTier,
                        "squadRank": pubgUser.squadRank,
                        "squadPoints": pubgUser.squadPoints,
                      }).then((value) async {
                        Navigator.pop(context);
                        await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("등록 완료!"),
                                content: Text(
                                    "유저 정보가 계정에 추가되었습니다\n수정이나 삭제는 \'내 정보\'에서 가능합니다"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardPage(index: 1),
                                          ),
                                          (route) => false);
                                    },
                                    child: Text("확인"),
                                  ),
                                ],
                              );
                            });
                      });
                      Navigator.pop(context);
                    },
                    child: Text("네"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("아니오"),
                  ),
                ],
              );
            });
      }
      if (value.docs.isEmpty) {
        await firestore
            .collection("user")
            .doc(getUser().uid)
            .collection("Playerunknown's Battlegrounds")
            .add({
          "accountId": pubgUser.accountId,
          "name": pubgUser.name,
          "soloTier": pubgUser.soloTier,
          "soloRank": pubgUser.soloRank,
          "soloPoints": pubgUser.soloPoints,
          "squadTier": pubgUser.squadTier,
          "squadRank": pubgUser.squadRank,
          "squadPoints": pubgUser.squadPoints,
        }).then((value) async {
          Navigator.pop(context);
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("등록 완료!"),
                  content:
                      Text("유저 정보가 계정에 추가되었습니다\n수정이나 삭제는 \'내 정보\'에서 가능합니다"),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(index: 1),
                            ),
                            (route) => false);
                      },
                      child: Text("확인"),
                    ),
                  ],
                );
              });
        });
      }
    });
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

    _dropFocusNode = FocusNode();
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
              autofocus: true,
              focusNode: _dropFocusNode,
              value: _server,
              onChanged: (value) {
                setState(() {
                  _server = value;
                });
                _dropFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_textFocusNode);
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
                        if (_validateText(_textController.text) == null) {
                          await getUserName(_textController.text);
                          setState(() {
                            _searching = false;
                          });
                          _animationController.forward();
                          print(pubgUser.toString());
                        }
                      },
                    )),
                onChanged: (value) {
                  setState(() {
                    _isEditingText = true;
                  });
                },
                onSubmitted: (value) async {
                  if (_validateText(_textController.text) == null) {
                    await getUserName(_textController.text);
                    setState(() {
                      _searching = false;
                    });
                    _animationController.forward();
                    print(pubgUser.toString());
                  }
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
                                      leading: getUserRankIcon(),
                                      title: Text(pubgUser.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: pubgUser.squadTier != null &&
                                              pubgUser.squadRank != null
                                          ? Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${pubgUser.squadTier} ${pubgUser.squadRank}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  TextSpan(text: ' | '),
                                                  TextSpan(
                                                      text:
                                                          "${pubgUser.squadPoints}PT",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                            )
                                          : Text("UNRANKED",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () async {
                                          await addUserData();
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
                              leading: getUserRankIcon(),
                              title: Text(pubgUser.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: pubgUser.squadTier != null &&
                                      pubgUser.squadRank != null
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${pubgUser.squadTier} ${pubgUser.squadRank}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(text: ' | '),
                                          TextSpan(
                                              text: "${pubgUser.squadPoints}PT",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    )
                                  : Text("UNRANKED",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
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
