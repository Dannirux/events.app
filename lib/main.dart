import 'package:flutter/material.dart';
import 'package:project_moviles/api/events_api.dart';
import 'package:project_moviles/pages/events.dart';
import 'package:project_moviles/pages/login.dart';
import 'package:project_moviles/pages/newest.dart';
import 'package:project_moviles/pages/register.dart';
import 'package:project_moviles/pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  // EventsApi.configureDio();
  runApp(MyRunApp());
}

class SessionManager {
  static Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print(prefs.getBool('isLoggedIn'));
    print('isLoggedIn');
    print(isLoggedIn);
    return isLoggedIn;
  }
}

class MyRunApp extends StatelessWidget {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: SessionManager.checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            isLoggedIn = snapshot.data!;
            return isLoggedIn ? Events() : MyLogin();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const MyLogin(),
        'events': (context) => const Events(),
        'search': (context) => const SearchPage(),
        'newest': (context) => MyNewest(),
      },
    );
  }
}
