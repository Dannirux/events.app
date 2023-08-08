import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/models/client_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/events_api.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showPass = true;
  bool isLoading = false;

  void saveSessionState(ModelClient modelClient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    String clientJson = jsonEncode(modelClient.toJson());
    prefs.setString('clientLogged', clientJson);
  }
  void _submit () async {
    try {
      setState(() {
        isLoading = true; // Activar el indicador de carga cuando se presiona el botón.
      });
      if (_formKey.currentState!.validate()) {
        final String email = _emailController.text;
        final String password = _passwordController.text;
        final Response response = await EventsApi.post('/clients/auth', {
          'email': email,
          'password': password,
        });
        Map<String, dynamic> responseData = response.data;
        ModelClient modelClient = ModelClient.fromJson(responseData);
        saveSessionState(modelClient);
        Navigator.pushNamedAndRemoveUntil(context, modelClient.interests.isEmpty ? 'newest' : 'events', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, corrija los errores en el formulario.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, // Set the background color to red.
            duration: Duration(seconds: 3), // Set the duration the snackbar will be visible.
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 45, top: 130),
              child: const Text(
                'UNIEVENT',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido!',
                                      style: TextStyle(
                                          fontSize: 27, fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'De vuelta',
                                      style: TextStyle(
                                          fontSize: 21, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Correo'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Correo electrónico",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail,
                                    color: Colors.grey,
                                  ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese un correo electrónico.';
                                }
                                return null; // Return null if the email is valid.
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Contraseña'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(),
                              obscureText: showPass,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Contraseña",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                  icon: Icon(
                                    showPass ? Icons.visibility_off : Icons.visibility,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese una contraseña.';
                                }
                                return null; // Return null if the input is valid.
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Olvidó su contraseña',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 15,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              width: double.infinity,
                              color: const Color.fromRGBO(4,188,212, 1),
                              child: TextButton(
                                onPressed: _submit,
                                child: isLoading
                                    ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    : Text(
                                  'Ingresar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register');
                                  },
                                  style: const ButtonStyle(),
                                  child: const Row(
                                    children: [
                                      Text('No posee una cuenta? ', style: TextStyle(
                                        color: Color(0xff4c505b),
                                      ),),
                                      Text(
                                        'Registrarse',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 18),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
