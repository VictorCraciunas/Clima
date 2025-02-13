import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Warnings {
  void showLocationServiceDialog(BuildContext context, Function() onTapFunction){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Services Disabled"),
          content: Text("Please enable location services to continue."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
                Geolocator.openLocationSettings();  // Opens the location settings
                onTapFunction(); /// we need to trigger again the function with the api call when the location is turned on
              },
            ),
          ],
        );
      },
    );
  }

  SnackBar errorSnackBar(){
    return SnackBar(content: Text("The app isn't going to work without location"));
  }
}