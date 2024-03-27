import 'package:flutter/material.dart';
import 'package:flutter_clima/utilities/constants.dart';
import 'package:flutter_clima/services/weather.dart';
import 'package:flutter_clima/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherLocation});
  late final weatherLocation;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  String? weatherIcon;
  int? dataTemper;
  String? dataNameCiTy;
  String? weatherMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.weatherLocation);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        dataTemper = 0;
        weatherIcon = "Errol";
        dataNameCiTy = '';
        weatherMessage = 'unable to get weather data';
        return;
      }
      int dataTemperature = weatherData['main']['temp'];
      dataTemper = dataTemperature.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      dataNameCiTy = weatherData['name'];
      weatherMessage = weatherModel.getMessage(dataTemper!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData =
                          await WeatherModel().getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typeName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if(typeName!= null){
                        var weatherData = await weatherModel.getCityWeather(typeName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$dataTemper°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $dataNameCiTy',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
