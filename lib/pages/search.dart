import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../api/events_api.dart';
import '../components/detail/place_detail_screen.dart';
import '../models/event.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Event>> eventsFuture;
  late bool showTendencies = true;

  Future<List<Event>> getEvents([String q = '']) async {
    try {
      showTendencies = false;
      final Response response = await EventsApi.get('/events', {'\$q': q});
      List<dynamic> data = response.data['data'];
      return data.map((eventJson) => Event.fromJson(eventJson)).toList();
    } catch (err) {
      print(err);
      return [];
    } finally {
      showTendencies = true;
    }
    //events = events.fromJson(response.data);
  }

  @override
  void initState() {
    super.initState();
    eventsFuture = getEvents();
  }

  onSearch(String search) {
    setState(() {
      eventsFuture = getEvents(search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.lightBlue,
        backgroundColor: Colors.white,
        title: Container(
          height: 38,
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[250],
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                hintText: "Búsqueda de eventos"),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            showTendencies
                ? const Column(
                    children: [
                      Text('Tendencias',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 5.0, // Espacio horizontal entre los elementos
                        runSpacing: 5.0,
                        children: [
                          ChipsMaterial(description: 'Java'),
                          ChipsMaterial(description: 'Sql'),
                          ChipsMaterial(description: 'Python'),
                          ChipsMaterial(description: 'Javascript'),
                          ChipsMaterial(description: 'React Native'),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 1,
                  ),
            const Text('Resultados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Expanded(
              child: Container(
                color: Colors.white,
                child: FutureBuilder<List<Event>>(
                  future:
                      eventsFuture, // Tu Future que retorna una lista de eventos
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Mientras la solicitud está en progreso, puedes mostrar un indicador de carga
                      return Container(
                        color: Colors.white, // Color de fondo de la pantalla
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Event>? auxEvents = snapshot.data;
                      if (auxEvents!.length > 0) {
                        return ListView.builder(
                          itemCount: auxEvents.length,
                          itemBuilder: (context, index) {
                            final ev = auxEvents[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder<dynamic>(
                                    pageBuilder: (_, animation, __) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: PlaceDetailScreen(
                                        event: ev,
                                        screenHeight:
                                            MediaQuery.of(context).size.height,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: eventListComponent(event: ev),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                                "No se encontraron eventos con esas coincidencias",
                                style: TextStyle(color: Colors.black)));
                      }
                    } else {
                      return const Center(
                          child: Text(
                              "No se encontraron eventos con esas coincidencias",
                              style: TextStyle(color: Colors.black)));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  eventListComponent({required Event event}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                NetworkImage(event.images.first, scale: double.maxFinite),
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.name,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 5,
              ),
              Text(event.description,
                  style: TextStyle(color: Colors.grey[500]),
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
        ],
      ),
    );
  }

}

class ChipsMaterial extends StatelessWidget {
  final String description;

  const ChipsMaterial({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Lógica para realizar la acción del botón
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(description),
    );
  }
}
