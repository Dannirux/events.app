import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_moviles/api/events_api.dart';
import 'package:project_moviles/models/client_model.dart';
import 'package:project_moviles/pages/layout_user.dart';
import 'package:project_moviles/pages/login.dart';
import 'package:project_moviles/pages/newest.dart';
import 'package:project_moviles/pages/register.dart';
import 'package:project_moviles/pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  EventsApi.configureDio();
  runApp(MyRunApp());
}

class SessionManager {
  static Future<dynamic> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('isLoggedIn');
    print(isLoggedIn);
    print(prefs.getString('clientLogged'));
    late String? clientJson = prefs.getString('clientLogged');
    // Verificar si clientJson no es nulo antes de decodificarlo
    Map<String, dynamic>? clientMap = clientJson != null ? jsonDecode(clientJson) : null;
    ModelClient modelClient = clientMap != null
        ? ModelClient.fromJson(clientMap)
        : ModelClient(id: '', names: '', surnames: '', email: '', phone: '', interests: []);
    return {'isLoggedIn': isLoggedIn, 'client': modelClient};
  }

}

class MyRunApp extends StatelessWidget {
  bool isLoggedIn = false;
  ModelClient? modelClient = ModelClient(id: '', names: '', surnames: '', email: '', phone: '', interests: []);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: SessionManager.checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            isLoggedIn = snapshot.data['isLoggedIn'];
            modelClient = snapshot.data['client'];
            return isLoggedIn ? modelClient!.interests.isEmpty ? MyNewest() : Events() : MyLogin();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const MyLogin(),
        'events': (context) => const Events(),
        'search': (context) => const SearchPage(),
        'newest': (context) => const MyNewest(),
      },
    );
  }
}
