import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_moviles/components/home/container_checks.dart';
import 'package:project_moviles/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/events_api.dart';

class RecommendedEvents extends StatefulWidget {
  const RecommendedEvents({Key? key}) : super(key: key);

  @override
  State<RecommendedEvents> createState() => _RecommendedEventsState();
}

class _RecommendedEventsState extends State<RecommendedEvents>
    with TickerProviderStateMixin {
  late Future<List<Event>> recommendeedEventsFuture;
  late Future<List<Event>> sportsEventsFuture;
  late Future<List<Event>> foodEventsFuture;

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
      print(status);
      String endpoint = '/events/recommendation/$codigoCliente';
      String query = status == 'no' ? '?' : '?interest=$status';
      final Response response = await EventsApi.get(
          endpoint + query);

      List<dynamic> data = response.data['data'];
      List<Event> events =
          data.map((eventJson) => Event.fromJson(eventJson)).toList();

      return events;
    } catch (err, stackTrace) {
      print("Error: $err");
      print("Stack trace: $stackTrace");
      print(err is DioError ? err!.response!.data!["message"].toString() : err.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    recommendeedEventsFuture = getMyEvents("no");
    sportsEventsFuture = getMyEvents("sports");
    foodEventsFuture = getMyEvents("food");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.maxFinite,
            child: FutureBuilder<List<Event>>(
              future: recommendeedEventsFuture,
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
          ),
          const SizedBox(height: 10),
          Text(
            "Deportes",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: 250,
            width: double.maxFinite,
            child: FutureBuilder<List<Event>>(
              future: sportsEventsFuture,
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
          ),
          const SizedBox(height: 10),
          Text(
            "Comida",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: 250,
            width: double.maxFinite,
            child: FutureBuilder<List<Event>>(
              future: foodEventsFuture,
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
