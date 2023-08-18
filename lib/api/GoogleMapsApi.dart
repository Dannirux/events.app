import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String address = 'Dirección de tu evento en Quito, Ecuador';

  final Map<String, dynamic>? location = await GoogleMapsApi.getCoordinatesFromAddress(address);

  if (location != null) {
    final double latitude = location['lat'];
    final double longitude = location['lng'];
    print('Latitud: $latitude, Longitud: $longitude');
  } else {
    print('No se encontraron coordenadas para la dirección proporcionada en Quito, Ecuador.');
  }
}

class GoogleMapsApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _apiKey = 'API_KEY';

  static Future<Map<String, dynamic>?> getCoordinatesFromAddress(String address) async {
    final Uri uri = Uri.parse('$_baseUrl?address=$address&key=$_apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
        // Validación adicional: Verificar si la dirección está en Quito, Ecuador
        final List<dynamic> addressComponents = data['results'][0]['address_components'];
        bool isQuitoEcuador = false;
        for (final component in addressComponents) {
          final List<String> types = List<String>.from(component['types']);
          if (types.contains('locality') && types.contains('political') && component['long_name'] == 'Quito') {
            isQuitoEcuador = true;
            break;
          }
        }

        if (isQuitoEcuador) {
          final location = data['results'][0]['geometry']['location'];
          return location;
        }
      }
    }

    return null;
  }
}
