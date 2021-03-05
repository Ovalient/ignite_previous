import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  RecentPage({Key key}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('최근 이력 페이지'),
    );
  }
}
