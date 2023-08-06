import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/components/events/place_cards.dart';

import '../../api/events_api.dart';
import '../../models/event.dart';
import '../detail/place_detail_screen.dart';

class AllEvents extends StatefulWidget {
  final VoidCallback onAction;
  const AllEvents({super.key, required this.onAction});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {

  late Future<List<Event>> eventsFuture;

  Future<List<Event>> getEvents () async {
    try{
      final Response response = await  EventsApi.get('/events');
      List<dynamic> data = response.data['data'];
      return data.map((eventJson) => Event.fromJson(eventJson)).toList();
    } catch (err) {
      print(err);
      return [];
    }
    //events = events.fromJson(response.data);
  }

  @override
  void  initState()  {
    super.initState();
    eventsFuture = getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onAction();
        return false; // Evita que la página se cierre
    },
      child: FutureBuilder<List<Event>>(
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
    );
  }
}