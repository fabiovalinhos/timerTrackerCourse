import 'package:flutter/material.dart';
import 'package:timer_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:timer_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:timer_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => Container(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }
}
