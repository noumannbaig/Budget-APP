import 'package:budget_app/Dashboard/dashboard_1.dart';
import 'package:budget_app/Dashboard/piechart.dart';
import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {
  const NavBar({ Key? key }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
    int _selectedIndex = 0;

    static const iconList = [
      Icon(Icons.home),
      Icon(Icons.pie_chart),
      Icon(Icons.add_circle_outline),
      Icon(Icons.history),
      Icon(Icons.more_horiz)
    ];

    void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // backgroundColor: primarycolor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // selectedItemColor: Colors.white,
    items:  <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'home'.tr,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pie_chart),
        label: 'expenses'.tr,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'add'.tr,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'history'.tr,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz),
        label: 'more'.tr,
      ),
    ],
    );

  }
}