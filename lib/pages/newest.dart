import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_moviles/api/events_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/client_model.dart';

class MyNewest extends StatefulWidget {
  const MyNewest({super.key});

  @override
  _MyNewestSate createState() => _MyNewestSate();

}

class _MyNewestSate extends State<MyNewest> {
  bool isLoading = false;
  bool isSaved = false;

  void _submit () async {
    try {
      setState(() {
        isLoading = true; // Activar el indicador de carga cuando se presiona el botón.
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      late String? clientJson = prefs.getString('clientLogged');
      // Verificar si clientJson no es nulo antes de decodificarlo
      Map<String, dynamic>? clientMap = clientJson != null ? jsonDecode(clientJson) : null;
      ModelClient modelClient = clientMap != null
          ? ModelClient.fromJson(clientMap)
          : ModelClient(id: '', names: '', surnames: '', email: '', phone: '', interests: []);
      print('hola');
      if (modelClient.id == '') {
        throw Exception('No se encontró los datos del usuario');
      }
      print(selectedIndexes);
      final Response response = await  EventsApi.put('/clients/' + modelClient.id, {
          'interests': selectedIndexes.toList(),
        });

      Map<String, dynamic> responseData = response.data;
      ModelClient updateClient = ModelClient.fromJson(responseData);
      String updateJson = jsonEncode(updateClient.toJson());
      prefs.setString('clientLogged', updateJson);
      setState(() {
        isSaved = true;
      });
      await Future.delayed(Duration(seconds: 3));

      Navigator.pushNamedAndRemoveUntil(context, 'events', (route) => false);
    } catch (err) {
      print(err);
      var error = '';
      error = err is DioError ? err!.response!.data!["message"].toString() : err.toString();
      print(err is DioError ? err!.response!.data!.toString() : err.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red, // Set the background color to red.
          duration: Duration(seconds: 3), // Set the duration the snackbar will be visible.
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Activar el indicador de carga cuando se presiona el botón.
      });
    }
  }

  final List<dynamic> items = [
    {
      "id": "sports",
      "url": "https://img.freepik.com/foto-gratis/herramientas-deportivas_53876-138077.jpg",
      "text": "Deporte"
    },
    {
      "id": "fashion",
      "url": "https://e00-telva.uecdn.es/assets/multimedia/imagenes/2022/05/29/16537884142596.jpg",
      "text": "Moda"
    },
    {
      "id": "food",
      "url": "https://www.cocinacaserayfacil.net/wp-content/uploads/2020/03/Recetas-faciles-de-cocinar-y-sobrevivir-en-casa-al-coronavirus_2.jpg",
      "text": "Comida"
    },
    {
      "id": "music",
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlPhCZz7LzLUM1YctZK2ncggWzTt1J_RuMtg&usqp=CAU",
      "text": "Música"
    },
    {
      "id": "tourism",
      "url": "https://s3.eu-central-1.amazonaws.com/images-blog-alventus/blog/28a4201159fcb5a6abe4089026e347c5.jpg",
      "text": "Turismo"
    },
    {
      "id": "culture",
      "url": "https://www.somosiberoamerica.org/wp-content/uploads/2022/09/Onda-Pais-Imagen-destacada.jpg",
      "text": "Cultura"
    },
    {
      "id": "engineering",
      "url": "https://lirp.cdn-website.com/7a848e1e/dms3rep/multi/opt/manager-supervisor-and-worker-discussing-about-production-results-and-new-strategy-in-factory-industrial-hall-640w.jpg",
      "text": "Ingeniería"
    },
    {
      "id": "animals",
      "url": "https://static.nationalgeographicla.com/files/styles/image_3200/public/nationalgeographic_2791022.jpg?w=1600&h=900&p=righttop",
      "text": "Animales"
    },
    {
      "id": "design",
      "url": "https://concepto.de/wp-content/uploads/2019/04/dise%C3%B1o-de-auto-e1555879905470.jpg",
      "text": "Diseño"
    }
  ];

  Set<String> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !isSaved ? Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(top: 70),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('¿Qué intereses tiene?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: Wrap(
                children: [
                  Text('Queremos conocerte un poco mejor, ', style: TextStyle(fontSize: 15)),
                  Text(selectedIndexes.length < 3 ? 'SELECCIONE ${3 - selectedIndexes.length}' : 'COMPLETO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // 2 columnas
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 45.0,
                padding: const EdgeInsets.all(20.0),
                children: List.generate(items.length, (index) {
                  final isSelected = selectedIndexes.contains(items[index]['id']);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        // Toggle para agregar o quitar el índice del elemento seleccionado.
                        isSelected ? selectedIndexes.remove(items[index]['id']) : selectedIndexes.add(items[index]['id']);
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(image:NetworkImage(items[index]["url"]),
                                fit: BoxFit.cover,
                                colorFilter: isSelected
                                    ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
                                    : null,),
                              borderRadius: BorderRadius.circular(20), // Ajusta el radio de los bordes.
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSelected ? Icons.check : Icons.visibility_off,
                                  color: isSelected ? Colors.white : Colors.black,
                                  size: isSelected ? 30 : 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(items[index]["text"])
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ) : Container(
          color: Colors.white,
          child: Center(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Column para que ocupe solo el espacio necesario
                children: [
                  Image(
                    image: AssetImage('assets/complete.png'),
                  ),
                  Text(
                    'Intereses configurados con éxito',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Estamos haciendo los ultimos ajustes . . .",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: !isSaved ? Colors.transparent : Colors.white,
        height: 80,
        padding: EdgeInsetsDirectional.all(15),
        child: !isSaved ? ElevatedButton(
          onPressed: selectedIndexes.length < 3 || isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70), // Ajusta el radio para darle forma redondeada
            ),
            primary: Colors.lightBlue, // Color de fondo del botón
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12), //ncho del botón
          ),
          child: Text(
            isLoading ? 'Guardando intereses ...' : 'Siguiente',
            style: TextStyle(fontSize: 18),
          ),
        ) : Text(''),
      ),
    );
  }
}