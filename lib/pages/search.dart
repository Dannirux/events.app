import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Aquí puedes declarar las variables necesarias para almacenar los valores de búsqueda y filtros
  // y manejar su estado en la página.

  @override
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