import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localibusao/models/user.dart';

import '../theme/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<dynamic, List<String>> casaList = {};
  Map<dynamic, List<String>> comodoList = {};

  final List<IconData> icons = [
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person,
  ];

  String teste = '123';
  @override
  void initState() {
    super.initState();
  }

  Future loadList() async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return 'Dados carregados';
    });
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
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Implemente a ação do ícone de olho aqui
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    'R\$ 100,00',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ]),
      body: FutureBuilder(
          future: loadList(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
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
                          markers: [
                            Marker(
                              point: const LatLng(-26.1109548, -48.6060343),
                              width: 50,
                              height: 50,
                              child: InkWell(
                                onTap: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Carro 1'),
                                        content: Text(
                                            'Motorista: ${widget.user.name}\nEmail: ${widget.user.email}'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.pin,
                                    ),
                                    const Text('Carro 1'),
                                  ],
                                ),
                              ),
                            ),
                            Marker(
                              point: const LatLng(-26.075724, -48.607309),
                              width: 50,
                              height: 50,
                              child: InkWell(
                                onTap: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Carro 1'),
                                        content: Text(
                                            'Motorista: ${widget.user.name}\nEmail: ${widget.user.email}'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.pin,
                                    ),
                                    const Text('Carro 2'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
