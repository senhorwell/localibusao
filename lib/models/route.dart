import 'package:latlong2/latlong.dart';
import 'package:localibusao/utils/data_parse.dart';

class RouteModel {
  late String id;
  late List<LatLng> points;

  RouteModel({
    this.id = "0",
    this.points = const [],
  });

  RouteModel parse(String key, Map data) {
    id = key;

    dataParse(data, "points", () {
      points = (data["points"] as List<dynamic>).map((e) {
        double lat = double.tryParse(e["lat"].toString()) ?? 0.0;
        double long = double.tryParse(e["long"].toString()) ?? 0.0;
        return LatLng(lat, long);
      }).toList();
    });

    return this;
  }
}
