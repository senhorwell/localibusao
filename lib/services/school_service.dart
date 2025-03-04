import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:localibusao/models/school.dart';

class SchoolService {
  late FirebaseDatabase fb;
  late DatabaseReference todos;

  Future<List<SchoolModel>> getSchools() async {
    List<SchoolModel> schools = [];

    try {
      fb = FirebaseDatabase.instance;
      todos = fb.ref().child('schools');

      await todos.once().then((snapshot) {
        Map<dynamic, dynamic> values =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (key != null) {
            SchoolModel route = SchoolModel().parse(key, value);
            schools.add(route);
          }
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return schools;
  }
}
