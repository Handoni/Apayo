import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  Map<String, dynamic>? _selectedHospital;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _getNearbyHospitals();
  }

  Future<void> _getNearbyHospitals() async {
    if (_currentPosition == null) return;
    const String url = 'http://52.79.91.82/api/get_hospitals';

    final Map<String, dynamic> requestBody = {
      "xPos": _currentPosition!.longitude,
      "yPos": _currentPosition!.latitude,
      "department": "정형외과"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = data['items'];

      setState(() {
        _markers = items.map((item) {
          final LatLng position = LatLng(
            double.parse(item['yPos']),
            double.parse(item['xPos']),
          );
          return Marker(
            markerId: MarkerId(item['yadmNm']),
            position: position,
            infoWindow: InfoWindow(
              title: item['yadmNm'],
            ),
            onTap: () {
              setState(() {
                _selectedHospital = item;
              });
            },
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load nearby hospitals');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.moveCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'APAYO TEAM 6',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '         RYU SOOJUNG         LEE SANGYUN         HYUN SOYOUNG',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 10,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 70,
        titleSpacing: 50, //앱바 왼쪽 간격추가
      ),
      // ~~~~~~~~~~~~~~~~~~~~~~app Bar~~~~~~~~~~~~~~~~~~~~~~~

      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 230, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "내 주변에 있는 정형외과",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          const SizedBox(
            child: Text(
              "표시된 전문의 수는 병원 전체의 전문의 수 입니다",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, // 가로 크기 조정
                height: MediaQuery.of(context).size.height * 0.75, // 세로 크기 조정
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // 모서리 둥글게 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // 그림자 위치 설정
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // 모서리 둥글게 설정
                  child: _currentPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition!,
                            zoom: 16.0,
                          ),
                          markers: Set<Marker>.of(_markers),
                          myLocationEnabled: true, // 내 위치 표시
                          myLocationButtonEnabled: true, // 내 위치 버튼 표시
                        ),
                ),
              ),
            ),
          ),
          if (_selectedHospital != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedHospital!['yadmNm'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('주소: ${_selectedHospital!['addr']}'),
                      Text('전화번호: ${_selectedHospital!['telno']}'),
                      Text('전문의 수: ${_selectedHospital!['specialistCount']}'),
                      Text('n차 병원: ${_selectedHospital!['hospitalGrade']}'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
