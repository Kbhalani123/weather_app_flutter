import 'package:weather_app_flutter/api/api_key.dart';

String apiURL(var lat, var lon) {
  String url;

  url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&unit=metric";

  return url;
}
