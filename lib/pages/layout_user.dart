import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/api/events_api.dart';
import 'package:project_moviles/components/events/my_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/detail/place_detail_screen.dart';
import '../components/events/all_events.dart';
import '../components/events/place_cards.dart';
import '../components/navigation.dart';
import '../models/event.dart';
import '../models/place.dart';

class Events extends StatefulWidget {
  const Events({super.key});
  
  @override
  State<Events> createState() => _EventsComponent();
}

class _EventsComponent extends State<Events> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MyPageHome(),
    AllEvents()
  ];

  void clearSessionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    Navigator.pushNamed(context, 'login');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Eventos', style: TextStyle(color: Colors.black))),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: clearSessionState,
          icon: const Icon(Icons.logout_outlined, color: Colors.black,),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'search');
            },
            icon: const Icon(CupertinoIcons.search, color: Colors.black),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.location_on),
      ),
      bottomNavigationBar: TravelNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          TravelNavigationBarItem(
            icon: CupertinoIcons.home,
            selectedIcon: CupertinoIcons.home,
          ),
          TravelNavigationBarItem(
            icon: CupertinoIcons.calendar,
            selectedIcon: CupertinoIcons.calendar_today,
          ),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }

}