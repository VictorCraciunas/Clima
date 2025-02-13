import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clima/utilities/warnings.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {


  WeatherModel weatherModel =WeatherModel();
  Warnings warnings = Warnings();

  ///this is called only once when the LoadingScreen widget is created
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {  /// This is used in order to pass the context
      getLocationData();
    });
  }
  void getLocationData() async {
    try {
      var weatherData = await weatherModel.getLocationWeather(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(weatherData: weatherData);
      }));
    } catch (error) {
      if (error.toString().contains('Location services are disabled.')) {
        warnings.showLocationServiceDialog(context, (){getLocationData();});  /// pop's the setting in order to turn on the location
      } else {
        ScaffoldMessenger.of(context).showSnackBar(warnings.errorSnackBar()); /// if the permisions are denied show an snackbar
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        /// Below is a loader from a package
        // child: SpinKitThreeInOut(size: 60.0,color: Colors.white,) // loader
        child: Lottie.asset('images/loader.json'), /// this is a downloaded loader
      ),
    );
  }
}