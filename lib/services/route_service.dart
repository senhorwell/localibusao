import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:localibusao/models/route.dart';

class RouteService {
  late FirebaseDatabase fb;
  late DatabaseReference todos;

  Future<List<RouteModel>> getRoutes() async {
    List<RouteModel> routes = [];

    try {
      fb = FirebaseDatabase.instance;
      todos = fb.ref().child('routes');

      await todos.once().then((snapshot) {
        Map<dynamic, dynamic> values =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (key != null) {
            RouteModel route = RouteModel().parse(key, value);
            routes.add(route);
          }
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return routes;
  }
}
