// ignore_for_file: unused_element
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationData {
  double latitude;
  double longitude;

  LocationData({required this.latitude, required this.longitude});
}

class GetPosition {
  final Location _location = Location();

  Future<LocationData> getLocation() async {
    try {
      var location = await _location.getLocation();
      return LocationData(
          latitude: location.latitude!, longitude: location.longitude!);
    } catch (e) {
      print('Errorrrrrrrrrr: $e ');
      return LocationData(latitude: 0.0, longitude: 0.0);
    }
  }
}

class WeatherApiClient {
  final String baseUrl = "https://api.open-meteo.com/v1/forecast/";
  

  Future<dynamic> getWeather() async {
    LocationData position = await GetPosition().getLocation();
    final uri =
        '$baseUrl?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch weather");
    }
  }
}
