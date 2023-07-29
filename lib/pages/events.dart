import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/detail/place_detail_screen.dart';
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
  late Future<List<Event>> eventsFuture;

  late List<Event> events;
  Future<List<Event>> getEvents () async {
    final Dio dio = Dio();
    try{
      final Response response = await  dio.get('http://ec2-3-83-46-123.compute-1.amazonaws.com:3003/events');
      List<dynamic> data = response.data['data'];
      return data.map((eventJson) => Event.fromJson(eventJson)).toList();
    } catch (err) {
      print(err);
      return [];
    }
    //events = events.fromJson(response.data);
  }
  void clearSessionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    Navigator.pushNamed(context, 'login');
  }
  @override
  void  initState()  {
    super.initState();
    eventsFuture = getEvents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Eventos', style: TextStyle(color: Colors.black))),
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: FutureBuilder<List<Event>>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<Event>? events = snapshot.data;
            return ListView.builder(
              itemCount: events?.length,
              itemExtent: 350,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 20, 20, kToolbarHeight + 20),
              itemBuilder: (context, index) {
                final ev = events?[index];
                return Hero(
                  tag: ev!.id,
                  child: Material(
                    child: PlaceCard(
                      event: ev,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder<dynamic>(
                            pageBuilder: (_, animation, __) => FadeTransition(
                              opacity: animation,
                              child: PlaceDetailScreen(
                                event: ev,
                                screenHeight: MediaQuery.of(context).size.height,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No se pudieron cargar los eventos'),
            );
          }
        },
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.location_on),
      ),
      bottomNavigationBar: TravelNavigationBar(
        onTap: (index) {
          print(index);
          if (index == 2) {
            print('hola');
          }
        },
        items: [
          TravelNavigationBarItem(
            icon: CupertinoIcons.chat_bubble,
            selectedIcon: CupertinoIcons.chat_bubble_fill,
          ),
          TravelNavigationBarItem(
            icon: CupertinoIcons.square_split_2x2,
            selectedIcon: CupertinoIcons.square_split_2x2_fill,
          ),
        ],
        currentIndex: 1,
      ),
    );
  }

}