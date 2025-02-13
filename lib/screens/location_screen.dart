import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/utilities/warnings.dart';
import 'package:http/http.dart';



Warnings warnings = Warnings();

class LocationScreen extends StatefulWidget {

  final weatherData;
  const LocationScreen({super.key, required this.weatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  int temperature = 0;
  String cityName= '';

  String weatherEmoji ='';
  String message = 'Error';
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData){
    setState(() {
      if(weatherData == null){
        return;
      }
      double temperatureDouble = weatherData['main']['temp'];
      this.temperature = temperatureDouble.toInt();
      var condition = weatherData['weather'][0]['id'];
      this.cityName = weatherData['name'];

      this.weatherEmoji = weatherModel.getWeatherIcon(condition);
      this.message = weatherModel.getMessage(temperature);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async{
                      var getWeatherData;
                      try{
                        getWeatherData = await weatherModel.getLocationWeather(context);
                        updateUI(getWeatherData);
                      }catch (error) {
                        if (error.toString().contains(
                            'Location services are disabled.')) {
                          warnings.showLocationServiceDialog(context,(){updateUI(getWeatherData);});

                          /// pop's the setting in order to turn on the location
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              warnings.errorSnackBar());

                          /// if the permisions are denied show an snackbar
                        }
                      }
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var typeName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                      if(typeName != null){
                        var getWeatherData = await weatherModel.getCityWeather(typeName);
                        updateUI(getWeatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature.toString(),
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherEmoji,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName!",
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