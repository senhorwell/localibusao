import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localibusao/models/driver.dart';
import 'package:localibusao/models/route.dart';
import 'package:localibusao/models/user.dart';
import 'package:localibusao/services/driver_service.dart';
import 'package:localibusao/services/route_service.dart';

import '../theme/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DriverModel> drivers = [];
  List<RouteModel> routes = [];
  List<Marker> markers = [];

  Future<void> loadMarkers() async {
    drivers = await DriverService().getDrivers();
    routes = await RouteService().getRoutes();
    markers = List.generate(routes.length, (i) {
      return Marker(
        point: LatLng(
            routes[i].points.last.latitude, routes[i].points.last.longitude),
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Carro ${routes[i].id}'),
                  content: Text(
                      'Motorista: ${widget.user.name}\nEmail: ${widget.user.email}'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          },
          child: Image.asset(
            AppImages.pin,
          ),
        ),
      );
    });
    if (kDebugMode) {
      print("markers");
      print(markers);
      print(markers.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/myAccount');
            },
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: loadMarkers(),
        builder: (context, snapshot) {
          return Stack(children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text('Onibus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(-26.1109548, -48.6060343),
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: markers,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Ação do botão
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff38b6ff), // Cor de fundo do botão
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0), // Tamanho do botão
                  ),
                  child: const Text(
                    'Iniciar rota',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
