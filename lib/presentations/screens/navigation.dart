// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:tubes_pbp/presentations/screens/explore/explore_screen.dart';
import 'package:tubes_pbp/presentations/screens/home_screen.dart';
import 'package:tubes_pbp/presentations/screens/profile/profile_screen.dart';
import 'package:tubes_pbp/presentations/screens/ticket/ticket_screen.dart';
import 'package:tubes_pbp/presentations/screens/transportasi/transportasi_screen.dart';

class Navigation extends StatefulWidget {
  final int? index;

  const Navigation({super.key, this.index});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.index ?? 0);
  }

  List<Widget> buildScreen() {
    return const [
      HomeScreen(),
      ExploreScreen(),
      TicketScreen(),
      Transportasi(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: buildScreen(),
      items: navBarsItems(),
      navBarStyle: NavBarStyle.style6,
      controller: _controller,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
    );
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.compass),
        title: ("Explore"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.tickets),
        title: ("Ticket"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.car_detailed),
        title: ("Transport"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_solid),
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
