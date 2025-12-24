import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import 'core/constants/colors.dart';
// import 'modules/explore/pages/explore_page.dart';
import 'modules/explore/pages/ad_page.dart';
import 'modules/favorite/pages/favorite_page.dart';
import 'modules/home/pages/home_page.dart';
import 'modules/profile/pages/profile_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex; // ambil dari parameter
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get listWidgets => [
    HomePage(),
    AdPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: listWidgets[selectedIndex],
        bottomNavigationBar: buildCustomBottomNavBar(),
      ),
    );
  }

  Widget buildCustomBottomNavBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 4,
          child: Row(
            children: List.generate(4, (index) {
              final isActive = selectedIndex == index;
              return SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    width: isActive ? 30 : 30,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.primaryTextColorGrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(MingCuteIcons.mgc_home_4_line),
              activeIcon: Icon(MingCuteIcons.mgc_home_4_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCuteIcons.mgc_news_2_line),
              activeIcon: Icon(MingCuteIcons.mgc_news_2_fill),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCuteIcons.mgc_message_4_line),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCuteIcons.mgc_user_2_line),
              activeIcon: Icon(MingCuteIcons.mgc_user_2_fill),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }
}
