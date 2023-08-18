import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_moviles/models/event.dart';

import '../detail/place_detail_screen.dart';

class ContainerChecks extends StatelessWidget {
  final List<Event> events;

  ContainerChecks({required this.events});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: events.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final event = events[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(
                  event: event,
                  screenHeight: MediaQuery.of(context).size.height,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            width: 180,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 123, 0, 245),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Text(
                  event.name,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
                ),
                Text(
                  '${DateFormat.MMMd().format(DateTime.now())}',
                  style:
                      GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.lightBlue,
              image: DecorationImage(
                image: NetworkImage(event.images[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
