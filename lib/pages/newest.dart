import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNewest extends StatefulWidget {
  const MyNewest({super.key});

  @override
  _MyNewestSate createState() => _MyNewestSate();

}

class _MyNewestSate extends State<MyNewest> {
  bool isLoading = false;


  void _submit () async {
    final Dio dio = Dio();
    try {
      setState(() {
        isLoading = true; // Activar el indicador de carga cuando se presiona el botón.
      });
        /*final Response response = await  dio.put('https://f7cd-102-177-161-43.ngrok-free.app/clients/', data: {
          'interests': [],
        });*/
        Navigator.pushNamed(context, 'events');
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
      "url": "https://img.freepik.com/foto-gratis/herramientas-deportivas_53876-138077.jpg",
      "text": 'Deporte',
    },
    {
      "url": "https://e00-telva.uecdn.es/assets/multimedia/imagenes/2022/05/29/16537884142596.jpg",
      "text": 'Moda',
    },
    {
      "url": "https://www.cocinacaserayfacil.net/wp-content/uploads/2020/03/Recetas-faciles-de-cocinar-y-sobrevivir-en-casa-al-coronavirus_2.jpg",
      "text": 'Comida',
    },
    {
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlPhCZz7LzLUM1YctZK2ncggWzTt1J_RuMtg&usqp=CAU",
      "text": 'Música',
    },
    {
      "url": "https://s3.eu-central-1.amazonaws.com/images-blog-alventus/blog/28a4201159fcb5a6abe4089026e347c5.jpg",
      "text": 'Turismo',
    },
    {
      "url": "https://www.somosiberoamerica.org/wp-content/uploads/2022/09/Onda-Pais-Imagen-destacada.jpg",
      "text": 'Cultura',
    },
    {
      "url": "https://lirp.cdn-website.com/7a848e1e/dms3rep/multi/opt/manager-supervisor-and-worker-discussing-about-production-results-and-new-strategy-in-factory-industrial-hall-640w.jpg",
      "text": 'Ingeniería',
    },
    {
      "url": "https://static.nationalgeographicla.com/files/styles/image_3200/public/nationalgeographic_2791022.jpg?w=1600&h=900&p=righttop",
      "text": 'Animales',
    },
    {
      "url": "https://concepto.de/wp-content/uploads/2019/04/dise%C3%B1o-de-auto-e1555879905470.jpg",
      "text": 'Diseño',
    }
  ];

  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Text('Escoja sus intereses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(20),
              child: Wrap(
                children: [
                  Text('Queremos conocerte un poco mejor, ', style: TextStyle(fontSize: 15)),
                  Text(selectedIndexes.length != 3 ? 'SELECCIONE ${3 - selectedIndexes.length}' : 'COMPLETO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
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
                  final isSelected = selectedIndexes.contains(index);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        // Toggle para agregar o quitar el índice del elemento seleccionado.
                        isSelected ? selectedIndexes.remove(index) : selectedIndexes.add(index);
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
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: selectedIndexes.length != 3 ? null : _submit,
          child: Text(
            'Siguiente',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}