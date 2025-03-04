import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class UserModel {
  late int id;
  late String name;
  late String email;

  UserModel({
    this.id = 0,
    this.name = "",
    this.email = "",
  });

  getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude != null || locationData.longitude != null) {
      return LatLng(locationData.latitude!, locationData.longitude!);
    }
    return null;
  }
}
