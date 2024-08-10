import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/views/home/home_page.dart';
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

class _BottomBarPageState extends State<BottomBarPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<Widget> widgets = [
      const HomePage(),
      const ExplorePage(),
      Text(
        'Index 2: SHARE',
      ),
      TextButton(
        onPressed: () async => await userProvider.signOut(),
        child: Text("SignOut", style: TextStyle(color: Colors.white)),
      ),
      Text(
        'Index 4: SETTINGS',
      ),
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
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              color: Colors.white,
            ),
            label: "EXPLORE",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: "SHARE"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                color: Colors.white,
              ),
              label: "ACCOUNT"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: "SETTINGS")
        ],
      ),
    );
  }
}
