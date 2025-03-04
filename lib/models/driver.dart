import 'package:localibusao/utils/data_parse.dart';

class DriverModel {
  late String id;
  late String name;
  late String email;
  late String car;
  late String photo;
  late String telephone;

  DriverModel({
    this.id = "0",
    this.name = "",
    this.email = "",
    this.car = "",
    this.photo = "",
    this.telephone = "",
  });

  DriverModel parse(String key, Map data) {
    id = key;

    dataParse(data, "name", () {
      name = data["name"].toString();
    });
    dataParse(data, "email", () {
      email = data["email"].toString();
    });
    dataParse(data, "car", () {
      car = data["car"].toString();
    });
    dataParse(data, "photo", () {
      photo = data["photo"].toString();
    });
    dataParse(data, "telephone", () {
      telephone = data["telephone"].toString();
    });

    return this;
  }
}
