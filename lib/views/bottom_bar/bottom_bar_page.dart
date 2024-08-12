import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/views/account/account_page.dart';
import 'package:bitstagram/views/home/home_page.dart';
import 'package:bitstagram/views/share/share_page.dart';
import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:bitstagram/widgets/appbart.dart';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:provider/provider.dart';

import '../explore/explore_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});
  static const route = "/bottom_bar";

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
              Pixel.home,
              size: 30,
              color: Colors.white,
            ),
            label: "HOME",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Pixel.search,
              size: 30,
              color: Colors.white,
            ),
            label: "EXPLORE",
            tooltip: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Pixel.imagenew,
              size: 30,
              color: Colors.white,
            ),
            label: "SHARE",
            tooltip: "Share",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Pixel.shuffle,
              size: 30,
              color: Colors.white,
            ),
            label: "WATCH",
            tooltip: "Watch",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Pixel.humanhandsup,
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
