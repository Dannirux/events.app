import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../api/events_api.dart';
import '../models/event.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Event>> eventsFuture;
  late bool showTendencies = true;

  Future<List<Event>> getEvents ([String q = '']) async {
    try{
      showTendencies = false;
      final Response response = await  EventsApi.get('/events', {
        '\$q': q
      });
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
    print('no debo');
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
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none
                ),
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500
                ),
                hintText: "Búsqueda de eventos"
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            showTendencies ? Column(
              children: [
                const Text('Tendencias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                const SizedBox(
                  height: 10,
                ),
                const Wrap(
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
                const SizedBox(
                  height: 1,
                ),
              ],
            ) : const SizedBox(
              height: 1,
            ),
            const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Expanded(
              child: Container(
                color: Colors.white,
                child:FutureBuilder<List<Event>>(
                  future: eventsFuture, // Tu Future que retorna una lista de eventos
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Mientras la solicitud está en progreso, puedes mostrar un indicador de carga
                      return Container(
                        color: Colors.white, // Color de fondo de la pantalla
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Si ocurre un error en la solicitud, manejarlo adecuadamente
                      return Center(child: Text('Error al obtener los eventos'));
                    } else if (snapshot.hasData) {
                      // La solicitud se completó con éxito, se puede acceder a los datos en snapshot.data
                      List<Event>? auxEvents = snapshot.data;
                        // Si hay eventos, mostrar la lista
                      if (auxEvents!.length > 0) {
                        return ListView.builder(
                          itemCount: auxEvents?.length,
                          itemBuilder: (context, index) {
                            return eventListComponent(event: auxEvents[index]);
                          },
                        );
                        } else {
                        return Center(child: Text("No se encontraron eventos con esas coincidencias", style: TextStyle(color: Colors.black)));
                      }
                    } else {
                      return Center(child: Text("No se encontraron eventos con esas coincidencias", style: TextStyle(color: Colors.black)));
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(event.images.first, scale: double.maxFinite),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                  SizedBox(height: 5,),
                  Text(event.description, style: TextStyle(color: Colors.grey[500]), overflow: TextOverflow.ellipsis),
                ]
            ),
          ),
          GestureDetector(
            onTap: () {
              print('holaaaaaaaa');
              setState(() {
                event.isFollowedByMe = !event.isFollowedByMe;
              });
            },
            child: AnimatedContainer(
                height: 35,
                width: 70,
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: event.isFollowedByMe ? Colors.blue[900] : Colors.lightBlue,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: event.isFollowedByMe ? Colors.transparent : Colors.lightBlue,)
                ),
                child: Center(
                    child: Text(event.isFollowedByMe ? 'Rechazar' : 'Asistir', style: TextStyle(color: event.isFollowedByMe ? Colors.white : Colors.white))
                )
            ),
          )
        ],
      ),
    );
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Correo electrónico",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Espacio entre el campo de entrada y el botón
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lógica para realizar la búsqueda
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 22.0,
                    ),
                    label: const Text('Filtrar'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Establece el radio de las esquinas del botón
                      ),
                      padding: const EdgeInsets.all(10), // Ajusta el relleno vertical del botón según sea necesario
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Tendencias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              const SizedBox(
                height: 10,
              ),
               const Wrap(
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
              const SizedBox(
                height: 20,
              ),
              const Text('Categorias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),

            ],
          ),
        ),
      ),
    );
  }*/

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
