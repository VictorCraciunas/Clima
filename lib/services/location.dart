import 'package:geolocator/geolocator.dart';


/// for gps location, we need to put a line of code in Android.xml
/// and for IOS in info.plist
/// these lines, request the user for accessing the GPS
class Location {
  double latitude = 0;
  double longitude = 0;


  Future<void> getCurrentLocation() async{
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      this.latitude = position.latitude;
      this.longitude = position.longitude;
    }
    catch(e){
      print(e);
    }
  }
}

