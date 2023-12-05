import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_slicing/utils/constant.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Position? _position;

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _position = position;
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * (1 / 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                _position != null
                    ? FlutterMap(
                        options: MapOptions(
                          initialCenter:
                              LatLng(_position!.latitude, _position!.longitude),
                          initialZoom: 12,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          CircleLayer(circles: [
                            CircleMarker(
                                point: LatLng(
                                    _position!.latitude, _position!.longitude),
                                radius: 3000,
                                useRadiusInMeter: true,
                                color: blue500.withOpacity(0.1),
                                borderColor: blue500,
                                borderStrokeWidth: 1.5)
                          ]),
                          MarkerLayer(markers: [
                            Marker(
                              point: LatLng(
                                  _position!.latitude, _position!.longitude),
                              child: const Icon(
                                Icons.person_pin_circle,
                                color: blue500,
                                size: 36,
                              ),
                            ),
                            const Marker(
                              point: LatLng(-7.7524801, 110.4910196),
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.green,
                                size: 36,
                              ),
                            ),
                          ])
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          )),
    );
  }
}
