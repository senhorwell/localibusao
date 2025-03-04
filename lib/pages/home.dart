import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localibusao/models/route.dart';
import 'package:localibusao/models/school.dart';
import 'package:localibusao/models/user.dart';
import 'package:localibusao/services/route_service.dart';
import 'package:localibusao/services/school_service.dart';

import '../theme/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final UserModel user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RouteModel> routes = [];
  List<SchoolModel> schools = [];
  List<Marker> markers = [];
  LatLng center = const LatLng(0, 0);
  double initialZoom = 13.0;
  late LatLngBounds bounds;
  bool routeInProgress = false;

  Future<void> loadMarkers() async {
    center = await widget.user.getLocation();
    routes = await RouteService().getRoutes();
    schools = await SchoolService().getSchools();

    setState(() {
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

      markers.add(Marker(
        point: LatLng(center.latitude, center.longitude),
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Você'),
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
            AppImages.yourPin,
          ),
        ),
      ));

      for (SchoolModel school in schools) {
        markers.add(Marker(
          point: school.point,
          width: 50,
          height: 50,
          child: InkWell(
            onTap: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(school.name),
                    content: Text(
                        'Endereço: ${school.address}\nTelefone: ${school.telephone}'),
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
            child: const Icon(
              Icons.other_houses,
              size: 50,
            ),
          ),
        ));
      }
      calculateCenter();

      bounds = calculateBounds(routes);
      initialZoom = calculateInitialZoom(bounds);
    });
  }

  void calculateCenter() {
    double sumLat = 0;
    double sumLng = 0;

    for (var route in routes) {
      sumLat += route.points.last.latitude;
      sumLng += route.points.last.longitude;
    }

    center = LatLng(sumLat / routes.length, sumLng / routes.length);
  }

  LatLngBounds calculateBounds(List<RouteModel> routes) {
    double minLat = routes[0].points.last.latitude;
    double maxLat = routes[0].points.last.latitude;
    double minLng = routes[0].points.last.longitude;
    double maxLng = routes[0].points.last.longitude;

    for (var route in routes) {
      if (route.points.last.latitude < minLat) {
        minLat = route.points.last.latitude;
      }
      if (route.points.last.latitude > maxLat) {
        maxLat = route.points.last.latitude;
      }
      if (route.points.last.longitude < minLng) {
        minLng = route.points.last.longitude;
      }
      if (route.points.last.longitude > maxLng) {
        maxLng = route.points.last.longitude;
      }
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  double calculateInitialZoom(LatLngBounds bounds) {
    // Este é um cálculo simplificado e pode precisar ser ajustado para seu caso específico
    double latDiff = bounds.northEast.latitude - bounds.southWest.latitude;
    double lngDiff = bounds.northEast.longitude - bounds.southWest.longitude;

    double zoom = 11.0; // Valor padrão de zoom

    if (latDiff > 0 || lngDiff > 0) {
      zoom = (18.0 - (latDiff + lngDiff)).clamp(0.0, 18.0);
    }

    return zoom;
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
      body: RefreshIndicator(
        onRefresh: () => loadMarkers(),
        child: FutureBuilder(
          future: loadMarkers(),
          builder: (context, snapshot) {
            if (center.latitude == 0) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF38b6ff),
                ),
              );
            }
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
                        child: Text(
                            'Rotas em andamento: ${!routeInProgress ? (routes.length) : routes.length + 1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: FlutterMap(
                        options: MapOptions(
                            initialCenter: center,
                            initialCameraFit: CameraFit.bounds(
                              bounds: bounds,
                              forceIntegerZoomLevel: true,
                              maxZoom: 17,
                            )),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          routeInProgress = !routeInProgress;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            routeInProgress ? Colors.red : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: routeInProgress
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.stop, color: Colors.white),
                                Text(
                                  'Parar rota',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                Text(
                                  'Iniciar rota',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
