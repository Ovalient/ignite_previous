import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ignite/model.dart';

class LeagueOfLegendsProfile extends StatefulWidget {
  LeagueOfLegendsProfile({Key key}) : super(key: key);

  @override
  _LeagueOfLegendsProfileState createState() => _LeagueOfLegendsProfileState();
}

class _LeagueOfLegendsProfileState extends State<LeagueOfLegendsProfile>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  TextEditingController _textController;
  FocusNode _textFocusNode;
  bool _isEditingText = false;

  final headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36',
    'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Origin': 'https://developer.riotgames.com',
    'X-Riot-Token': 'RGAPI-c89a98a2-c755-4d2d-a5ce-c6a3f6b216a9',
  };

  getSummonerName(String summonerName) async {
    final url =
        'https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/' +
            summonerName;
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> summonerData = jsonDecode(response.body);
      await getSummonerData(summonerData);
    } else {
      throw Exception('No data found');
    }
  }

  getSummonerData(Map<String, dynamic> summonerData) async {
    final url =
        'https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/' +
            summonerData['id'];
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Summoner summoner;
      final List<dynamic> leagueData = jsonDecode(response.body);
      leagueData.forEach((element) {
        if (element['queueType'] == 'RANKED_SOLO_5x5') {
          summoner = Summoner(
            name: summonerData['name'],
            profileIconId: summonerData['profileIconId'],
            summonerLevel: summonerData['summonerLevel'],
            soloTier: element['tier'],
            soloRank: element['rank'],
            leaguePoints: element['leaguePoints'],
          );
        } else {
          summoner = Summoner(
            name: summonerData['name'],
            profileIconId: summonerData['profileIconId'],
            summonerLevel: summonerData['summonerLevel'],
          );
        }
        return summoner;
      });
    } else {
      throw Exception('No data found');
    }
  }

  String _validateText(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return 'Username can\'t be empty';
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.text = null;
    _textFocusNode = FocusNode();

    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animation.addListener(() => setState(() {}));
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
                    labelText: 'Summoner\'s Name',
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
                          _animationController.forward();
                          await getSummonerName(_textController.text);
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
                    _animationController.forward();
                    await getSummonerName(_textController.text);
                  }
                },
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _animation,
              child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: FutureBuilder()),
            )
          ],
        ),
      ),
    );
  }
}
