import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
///Responsible for retrieving weather data.
class DataFetcher {
  String? longitude;
  String? latitude;
  String unit = 'metric';
  String currentData = "";
  String data= "";
  String? city;
  String? currentWeatherUrl;
  String? weatherUrl;
  ///Go to OpenWeatherMap, copy your API key and replace it
  String? appid = dotenv.env['OPENWEATHER_API_KEY'];
  Future<void> fetchData() async {
    if (longitude != null && latitude != null) {
      http.Response response = await http.get(Uri.parse(
          '${currentWeatherUrl}lat=$latitude&lon=$longitude&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      currentData = response.body;
      }
      response = await http.get(Uri.parse(
          '${weatherUrl}lat=$latitude&lon=$longitude&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      data = response.body;
      }
    }
    else {
      http.Response response = await http.get(
          Uri.parse('${currentWeatherUrl}q=$city&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      currentData = response.body;
      }
      response = await http
          .get(Uri.parse('${weatherUrl}q=$city&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      data = response.body;
      }
    }
  }
}
