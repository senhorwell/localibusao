import 'package:latlong2/latlong.dart';
import 'package:localibusao/utils/data_parse.dart';

class SchoolModel {
  late String id;
  late LatLng point;
  late String name;
  late String address;
  late String email;
  late String photo;
  late String telephone;

  SchoolModel({
    this.id = "0",
    this.address = "",
    this.name = "",
    this.email = "",
    this.photo = "",
    this.telephone = "",
  });

  SchoolModel parse(String key, Map data) {
    id = key;

    dataParse(data, "name", () {
      name = data["name"];
    });

    dataParse(data, "address", () {
      address = data["address"];
    });

    dataParse(data, "email", () {
      email = data["email"];
    });

    dataParse(data, "photo", () {
      photo = data["photo"];
    });

    dataParse(data, "telephone", () {
      telephone = data["telephone"];
    });

    dataParse(data, "lat", () {
      if (data["lat"] != null && data["long"] != null) {
        double lat = double.tryParse(data["lat"].toString()) ?? 0.0;
        double long = double.tryParse(data["long"].toString()) ?? 0.0;
        point = LatLng(lat, long);
      }
    });

    return this;
  }
}
