import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_moviles/components/events/my_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../api/GoogleMapsApi.dart';
import '../components/detail/widgets/GoogleMapsScreen.dart';
import '../components/events/all_events.dart';
import '../components/navigation.dart';
import '../api/events_api.dart';
import '../models/event.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsComponent();
}

class _EventsComponent extends State<Events> {
  int _selectedIndex = 0;

  void _setIndexZero() {
    setState(() {
      _selectedIndex = 0;
      print(
          'El componente hijo notificó al componente padre. _selectedIndex = $_selectedIndex');
    });
  }

  void clearSessionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('clientLogged');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  Future<List<Event>> getMyInvitationalEvents(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientJson = prefs.getString('clientLogged');

      String codigoCliente = "";

      if (clientJson != null) {
        Map<String, dynamic> clientData = jsonDecode(clientJson);
        codigoCliente = clientData['_id'];
      }

      final Response response = await EventsApi.get(
          '/invitations?client=' + codigoCliente + '&status=$status');
      List<dynamic> data = response.data['data'];

      List<Event> events = [];

      for (final eventJson in data) {
        Event event = Event.fromJson(eventJson['event']);

        // Obtener las coordenadas desde Google Maps API
        Map<String, dynamic>? coordinates =
        await GoogleMapsApi.getCoordinatesFromAddress(event.address);

        if (coordinates != null) {
          double latitude = coordinates['lat'];
          double longitude = coordinates['lng'];

          // Agregar coordenadas a eventos de invitación
          event.latitude = latitude;
          event.longitude = longitude;

          events.add(event);
        }
      }

      return events;
    } catch (err, stackTrace) {
      print("Error: $err");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  Future<List<Event>> getMyEvents(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientJson = prefs.getString('clientLogged');

      String codigoCliente = "";

      if (clientJson != null) {
        Map<String, dynamic> clientData = jsonDecode(clientJson);
        codigoCliente = clientData['_id'];
      }

      String endpoint = '/events/recommendation/$codigoCliente';
      String query = status == 'no' ? '?' : '?interest=$status';
      final Response response = await EventsApi.get(endpoint + query);

      List<dynamic> data = response.data['data'];
      List<Event> events = [];

      for (final eventJson in data) {
        // Obtener las coordenadas desde Google Maps API
        Map<String, dynamic>? coordinates =
        await GoogleMapsApi.getCoordinatesFromAddress(eventJson['address']);

        if (coordinates != null) {
          double latitude = coordinates['lat'];
          double longitude = coordinates['lng'];

          // Crear una instancia de Event con las coordenadas
          Event event = Event.fromJson(eventJson);
          event.latitude = latitude;
          event.longitude = longitude;
          events.add(event);
        }
      }

      // Agregar eventos de invitación con coordenadas
      List<Event> invitationalEvents = await getMyInvitationalEvents(status);
      events.addAll(invitationalEvents);

      return events;
    } catch (err, stackTrace) {
      print("Error: $err");
      print("Stack trace: $stackTrace");
      print(err is DioError
          ? err!.response!.data!["message"].toString()
          : err.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 1
            ? Center(
            child: const Text('Eventos', style: TextStyle(color: Colors.black)))
            : Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: clearSessionState,
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.black,
          ),
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
      body: _selectedIndex == 0
          ? MyPageHome()
          : AllEvents(onAction: _setIndexZero),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            List<Event> recommendedEvents = await getMyEvents("no");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleMapScreen(
                  events: recommendedEvents,
                ),
              ),
            );
          } catch (error) {
            print("Error obteniendo eventos recomendados: $error");
          }
        },
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