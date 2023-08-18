  import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_moviles/components/home/check_events.dart';
import 'package:project_moviles/components/home/date_now.dart';
import 'package:project_moviles/components/home/recommended_events.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageHome extends StatefulWidget {
  const MyPageHome({super.key});

  @override
  State<MyPageHome> createState() => _MyPageHomeState();
}

class _MyPageHomeState extends State<MyPageHome> {
  String _clientName = "";

  @override
  void initState() {
    super.initState();
    _loadClientName();
  }

  Future<void> _loadClientName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String? clientJson = prefs.getString('clientLogged');

    if (clientJson != null) {
    Map<String, dynamic> clientData = jsonDecode(clientJson);  // Decodifica el JSON a un mapa
    String clientName = clientData['names'];  // Accede al campo 'names' del mapa
    setState(() {
      _clientName = clientName;  // Establece el nombre del cliente en _clientName
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Hace q cierre
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Bienvenido, ",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      TextSpan(
                        text: "$_clientName!",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  "Ten un buen día!",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 15),
                const DateNow(),
                CheckEvents(),
                const SizedBox(height: 10),
                Text(
                  "Sugeridos para ti",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RecommendedEvents()
              ],
            ),
          ),
          /*Padding(
            padding:
            const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 0),
            child: OverView(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                ProgressCard(ProjectName: "Project", CompletedPercent: 30),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}