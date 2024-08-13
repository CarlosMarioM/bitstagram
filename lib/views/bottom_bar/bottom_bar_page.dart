import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/views/account/account_page.dart';
import 'package:bitstagram/views/home/home_page.dart';
import 'package:bitstagram/views/share/share_page.dart';
import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:bitstagram/widgets/appbart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../explore/explore_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});
  static const route = "/bottom_bar";

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      const HomePage(),
      const ExplorePage(),
      const SharePage(),
      const WatchPage(),
      AccountPage()
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              stretch: false,
              stretchTriggerOffset: 300.0,
              expandedHeight: 70.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'BITSTAGRAM',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ];
        },
        body: widgets[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        enableFeedback: true,
        onTap: (value) => setState(() {
          index = value;
        }),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white54),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            label: "HOME",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            label: "EXPLORE",
            tooltip: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_sharp,
              size: 30,
              color: Colors.white,
            ),
            label: "SHARE",
            tooltip: "Share",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shuffle,
              size: 30,
              color: Colors.white,
            ),
            label: "WATCH",
            tooltip: "Watch",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.run_circle_outlined,
              size: 30,
              color: Colors.white,
            ),
            label: "ACCOUNT",
            tooltip: "Account",
          ),
        ],
      ),
    );
  }
}
