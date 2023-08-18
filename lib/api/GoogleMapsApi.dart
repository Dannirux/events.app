import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleMapsApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _apiKey = 'AIzaSyC7BD37UpC2X6ZL7DDF2KcRHWnNlsh3ODo';

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
