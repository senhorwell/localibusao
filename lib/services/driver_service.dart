import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:localibusao/models/driver.dart';

class DriverService {
  late FirebaseDatabase fb;
  late DatabaseReference todos;

  Future<List<DriverModel>> getDrivers() async {
    List<DriverModel> drivers = [];
    try {
      fb = FirebaseDatabase.instance;
      todos = fb.ref().child('drivers');

      await todos.once().then((snapshot) {
        Map<dynamic, dynamic> values =
            snapshot.snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          if (key != null) {
            DriverModel driver = DriverModel().parse(key, value);
            drivers.add(driver);
          }
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return drivers;
  }
}
