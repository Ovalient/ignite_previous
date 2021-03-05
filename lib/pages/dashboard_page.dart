import 'package:flutter/material.dart';
import 'package:ignite/utils/theme.dart';

import 'dashboard/main_page.dart';
import 'dashboard/my_page.dart';
import 'dashboard/recent_page.dart';
import 'dashboard/serach_page.dart';

class DashboardPage extends StatefulWidget {
  static const String id = "/dashboardPage";
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _navItems = [
    new BottomNavigationBarItem(icon: Icon(Icons.home), label: '메인'),
    new BottomNavigationBarItem(
        icon: Icon(Icons.person_search), label: '동료 찾기'),
    new BottomNavigationBarItem(icon: Icon(Icons.access_time), label: '최근 이력'),
    new BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: '내 정보'),
  ];

  void onTabNav(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: <Widget>[
            MainPage(),
            SearchPage(),
            RecentPage(),
            MyPage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        onTap: onTabNav,
        currentIndex: _currentIndex,
        items: _navItems,
      ),
    );
  }
}
