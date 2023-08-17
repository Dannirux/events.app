import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/components/home/container_checks.dart';
import 'package:project_moviles/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/events_api.dart';

class CheckEvents extends StatefulWidget {
  const CheckEvents({Key? key}) : super(key: key);

  @override
  State<CheckEvents> createState() => _CheckEventsState();
}

class _CheckEventsState extends State<CheckEvents>
    with TickerProviderStateMixin {
  late Future<List<Event>> upcomingEventsFuture;
  late Future<List<Event>> completedEventsFuture;
  late Future<List<Event>> canceledEventsFuture;
  late TabController tabController;

  Future<List<Event>> getMyEvents(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientJson = prefs.getString('clientLogged');

      String codigoCliente = "";

      if (clientJson != null) {
        Map<String, dynamic> clientData = jsonDecode(clientJson);
        codigoCliente = clientData['_id'];
        setState(() {
          codigoCliente;
        });
      }

      final Response response = await EventsApi.get(
          '/invitations?client=' + codigoCliente + '&status=$status');
      List<dynamic> data = response.data['data'];

      List<Event> events =
          data.map((eventJson) => Event.fromJson(eventJson['event'])).toList();

      return events;
    } catch (err, stackTrace) {
      print("Error: $err");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
    upcomingEventsFuture = getMyEvents("upcoming");
    completedEventsFuture = getMyEvents("completed");
    canceledEventsFuture = getMyEvents("canceled");
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.black,
            isScrollable: true,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: Colors.black)),
            padding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.grey.shade400,
            tabs: [
              Tab(
                text: "Por venir",
              ),
              Tab(
                text: "Completos",
              ),
              Tab(
                text: "Cancelados",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 250,
            width: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                FutureBuilder<List<Event>>(
                  future: upcomingEventsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Event> events = snapshot.data!;
                      if (!events.isEmpty) {
                        return ContainerChecks(
                            events: events); //
                      } else {
                        return Center(child: Text('No se encontraron eventos'));
                      }
                    } else {
                      return Center(child: Text('No se encontraron eventos'));
                    }
                  },
                ),
                FutureBuilder<List<Event>>(
                  future: completedEventsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Event> events = snapshot.data!;
                      return ContainerChecks(
                          events: events); // Pasar la lista de eventos
                    } else {
                      return Center(child: Text('No se encontraron eventos'));
                    }
                  },
                ),
                FutureBuilder<List<Event>>(
                  future: canceledEventsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Event> events = snapshot.data!;
                      return ContainerChecks(
                          events: events); // Pasar la lista de eventos
                    } else {
                      return Center(child: Text('No se encontraron eventos'));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleTab extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return CirclePainter();
  }
}

class CirclePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = Colors.black54;
    final Offset CirclePostion =
        Offset(configuration.size!.width - 3.0, configuration.size!.height / 2);
    canvas.drawCircle(offset + CirclePostion, 4, _paint);
  }
}
