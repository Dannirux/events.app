import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/api/events_api.dart';
import 'package:project_moviles/components/detail/widgets/place_images_page_view.dart';
import 'package:project_moviles/extensions/text_theme_x.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/event.dart';
import '../../../models/place.dart';
import '../../events/gradient_status_tag.dart';
import '../../events/translate_animation.dart';

class AnimatedDetailHeader extends StatelessWidget {
  
  const AnimatedDetailHeader({
    super.key,
    required this.event,
    required this.topPercent,
    required this.bottomPercent, 
  });

  final Event event;
  final double topPercent;
  final double bottomPercent;
  

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final imagesUrl = event.images;
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: event.id,
          child: Material(
            child: ClipRect(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: (20 + topPadding) * (1 - bottomPercent),
                      bottom: 160 * (1 - bottomPercent),
                    ),
                    child: Transform.scale(
                      scale: lerpDouble(1, 1.3, bottomPercent),
                      child: PlaceImagesPageView(imagesUrl: imagesUrl),
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    left: -60 * (1 - bottomPercent),
                    child: const BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    right: -60 * (1 - bottomPercent),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: lerpDouble(-100, 140, topPercent)!
                        .clamp(topPadding + 10, 140),
                    left: lerpDouble(100, 20, topPercent)!.clamp(20.0, 50.0),
                    right: 20,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: bottomPercent < 1 ? 0 : 1,
                      child: Text(
                        event.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              lerpDouble(0, 40, topPercent)!.clamp(20.0, 40.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 200,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: bottomPercent < 1 ? 0 : 1,
                      child: Opacity(
                        opacity: topPercent,
                        child: GradientStatusTag(
                          type: 'event',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(color: Colors.white, height: 10),
        ),
        Positioned.fill(
          top: null,
          bottom: -140 * (1 - topPercent),
          child: TranslateAnimation(
            child: _LikesAndSharesContainer(event: event),
          ),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: _UserInfoContainer(event: event),
          ),
        )
      ],
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  const _UserInfoContainer({
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://aka-cdn.uce.edu.ec/ares/tmp/SIIU/anuncios/sello_400.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                event.university,
                style: context.bodyText1,
              ),
              Text(
                'yesterday at 9:10 p.m.',
                style: context.bodyText2.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _LikesAndSharesContainer extends StatelessWidget {
  const _LikesAndSharesContainer({
    required this.event,
  });

  final Event event;
  static String _clientId = "";

  Future<void> _loadClientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String? clientJson = prefs.getString('clientLogged');

    if (clientJson != null) {
      Map<String, dynamic> clientData =
          jsonDecode(clientJson); // Decodifica el JSON a un mapa
       _clientId = clientData['_id']; // Accede al campo 'names' del mapa
    
    }
  }

   void _asistir(BuildContext context) async{

    final Map<String, dynamic> requestBody = {
      "client": _clientId,
      "event": event.id
    };

    print(requestBody);
    try {
      // Realizar la solicitud POST
      final Response response = await EventsApi.post('/invitations', requestBody);

      // Verificar la respuesta y realizar acciones según sea necesario
      if (response.statusCode == 201) {
        // La solicitud se realizó con éxito
        print("Invitación enviada exitosamente");
        // Puedes actualizar la UI según sea necesario aquí
      } else {
        // Ocurrió un error en la solicitud
        print("Error al enviar la invitación");
        // Puedes manejar el error o mostrar un mensaje al usuario aquí
      }
    } catch (err) {
      // Manejar el error en caso de que ocurra una excepción
      print("Error al enviar la invitación: $err");
      var error = '';
      error = err is DioError
          ? err!.response!.data!["message"].toString()
          : err.toString();
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
      // Puedes manejar el error o mostrar un mensaje al usuario aquí
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: context.subtitle1,
              shape: const StadiumBorder(),
            ),
            icon: const Icon(
              CupertinoIcons.heart,
              size: 26,
            ),
            label: Text('320'),
          ),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: context.subtitle1,
              shape: const StadiumBorder(),
            ),
            icon: const Icon(
              CupertinoIcons.reply,
              size: 26,
            ),
            label: Text('420'),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () async{
              _loadClientId().then((value) => _asistir(context));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade600,
              textStyle: context.subtitle1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: const Icon(
              Icons.check_circle_outlined,
              size: 26,
            ),
            label: const Text('Asistir'),
          ),
        ],
      ),
    );
  }
}
