import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ignite/model.dart';
import 'package:ignite/pages/dashboard/serach_page.dart';
import 'package:ignite/pages/dashboard_page.dart';
import 'package:ignite/utils/firebase_provider.dart';

class LeagueOfLegendsProfile extends StatefulWidget {
  LeagueOfLegendsProfile({Key key}) : super(key: key);

  @override
  _LeagueOfLegendsProfileState createState() => _LeagueOfLegendsProfileState();
}

class _LeagueOfLegendsProfileState extends State<LeagueOfLegendsProfile>
    with SingleTickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;

  AnimationController _animationController;
  Animation _animation;

  TextEditingController _textController;
  FocusNode _textFocusNode;
  bool _isEditingText = false;

  Summoner summoner;
  bool _searching = false;

  final headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36',
    'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Origin': 'https://developer.riotgames.com',
    'X-Riot-Token': 'RGAPI-7fb26a98-5026-425c-91bc-bf1499676e17',
  };

  Future<Summoner> getSummonerName(String summonerName) async {
    setState(() {
      _searching = true;
    });
    final url =
        "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +
            summonerName;
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> summonerData = jsonDecode(response.body);
      return await getSummonerData(summonerData);
    } else {
      return null;
    }
  }

  Future<Summoner> getSummonerData(Map<String, dynamic> summonerData) async {
    final url =
        "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/" +
            summonerData['id'];
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> leagueData = jsonDecode(response.body);
      if (leagueData.isEmpty) {
        summoner = Summoner(
          id: summonerData["id"],
          name: summonerData["name"],
          profileIconId: summonerData["profileIconId"],
          summonerLevel: summonerData["summonerLevel"],
        );
      } else {
        if (leagueData[0]["queueType"] == "RANKED_SOLO_5x5") {
          if (leagueData.length > 1) {
            summoner = Summoner(
              id: summonerData["id"],
              name: summonerData["name"],
              profileIconId: summonerData["profileIconId"],
              summonerLevel: summonerData["summonerLevel"],
              soloTier: leagueData[0]["tier"],
              soloRank: leagueData[0]["rank"],
              soloLeaguePoints: leagueData[0]["leaguePoints"],
              flexTier: leagueData[1]["tier"],
              flexRank: leagueData[1]["rank"],
              flexLeaguePoints: leagueData[1]["leaguePoints"],
            );
          } else {
            summoner = Summoner(
                id: summonerData["id"],
                name: summonerData["name"],
                profileIconId: summonerData["profileIconId"],
                summonerLevel: summonerData["summonerLevel"],
                soloTier: leagueData[0]["tier"],
                soloRank: leagueData[0]["rank"],
                soloLeaguePoints: leagueData[0]["leaguePoints"]);
          }
        } else if (leagueData[0]["queueType"] == "RANKED_FLEX_SR") {
          summoner = Summoner(
            id: summonerData["id"],
            name: summonerData["name"],
            profileIconId: summonerData["profileIconId"],
            summonerLevel: summonerData["summonerLevel"],
            flexTier: leagueData[0]["tier"],
            flexRank: leagueData[0]["rank"],
            flexLeaguePoints: leagueData[0]["leaguePoints"],
          );
        }
      }
      return summoner;
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

  addSummonerData() async {
    await firestore
        .collection("user")
        .doc(getUser().uid)
        .collection("League of Legends")
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
                          .collection("League of Legends")
                          .doc(docId)
                          .delete();

                      await firestore
                          .collection("user")
                          .doc(getUser().uid)
                          .collection("League of Legends")
                          .add({
                        "accountId": summoner.id,
                        "name": summoner.name,
                      }).then((value) async {
                        Navigator.pop(context);
                        await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("등록 완료!"),
                                content: Text(
                                    "소환사 정보가 계정에 추가되었습니다\n수정이나 삭제는 \'내 정보\'에서 가능합니다"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardPage(index: 1),
                                        ),
                                      );
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
            .collection("League of Legends")
            .add({
          "accountId": summoner.id,
          "name": summoner.name,
        }).then((value) async {
          Navigator.pop(context);
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("등록 완료!"),
                  content:
                      Text("소환사 정보가 계정에 추가되었습니다\n수정이나 삭제는 \'내 정보\'에서 가능합니다"),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage(index: 1)));
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
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animation.addListener(() => setState(() {}));

    super.initState();
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(color: Colors.redAccent))),
              child: TextField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                      fillColor: Colors.redAccent,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Summoner\'s Name",
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
                            summoner =
                                await getSummonerName(_textController.text);
                            setState(() {
                              _searching = false;
                            });
                            _animationController.forward();
                            print(summoner.toString());
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
                      summoner = await getSummonerName(_textController.text);
                      setState(() {
                        _searching = false;
                      });
                      _animationController.forward();
                      print(summoner.toString());
                    }
                  }),
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
                  child: summoner == null
                      ? Text("소환사 정보가 없습니다")
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
                                        leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://ddragon.leagueoflegends.com/cdn/11.6.1/img/profileicon/${summoner.profileIconId}.png"),
                                            child: Text(
                                                "${summoner.summonerLevel}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12))),
                                        title: Text(summoner.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: summoner.soloTier != null &&
                                                summoner.soloRank != null
                                            ? Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "${summoner.soloTier} ${summoner.soloRank}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    TextSpan(text: " | "),
                                                    TextSpan(
                                                        text:
                                                            "${summoner.soloLeaguePoints}LP",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              )
                                            : Text("UNRANKED",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () async {
                                            await addSummonerData();
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
                                  });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://ddragon.leagueoflegends.com/cdn/11.6.1/img/profileicon/${summoner.profileIconId}.png"),
                                  child: Text('${summoner.summonerLevel}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              title: Text(summoner.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: summoner.soloTier != null &&
                                      summoner.soloRank != null
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${summoner.soloTier} ${summoner.soloRank}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(text: ' | '),
                                          TextSpan(
                                              text:
                                                  "${summoner.soloLeaguePoints}LP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    )
                                  : Text("UNRANKED",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                              trailing: Icon(Icons.keyboard_arrow_right),
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
