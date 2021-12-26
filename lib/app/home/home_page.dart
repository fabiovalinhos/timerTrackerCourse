import 'package:flutter/material.dart';
import 'package:timer_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:timer_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: (item) {},
    );
  }
}
