import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // HTTP 요청용
import 'dart:convert'; // JSON 디코딩용

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition; // 초기 위치용, nullable한 LatLng 타입
  List<Marker> _markers = []; // 병원 위치 마커 리스트

  @override
  void initState() {
    super.initState();
    _determinePosition(); // 현재 위치함수 호출
  }

  Future<void> _determinePosition() async {
    // 위치 불러오기 함수
    bool serviceEnabled;
    LocationPermission permission;

    // 권한 요청
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission(); // 요청 될때까지 로딩
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
        // 위치 가져오기 성공하면
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(
          position.latitude, position.longitude); // _currentPosition 업데이트
    });
    print("여기까진 성공~");
    // 위치가 업데이트되면 주변 병원을 검색
    _getNearbyHospitals();
  }

  Future<void> _getNearbyHospitals() async {
    if (_currentPosition == null) return;

    const String apiKey = 'AIzaSyD4uENvK0mfa6lIvQFngXHwGp369y-zyoA';
    //백에서 진료과를 넘겨주면 keyword에 저장하는 로직 추가해야됨
    final String keyword = '정형외과';
    final String url =
        'http://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&&keyword=$keyword&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        _markers = results.map((result) {
          //result 리스트
          final LatLng position = LatLng(
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
          );

          return Marker(
            //마커로 변환
            markerId: MarkerId(result['place_id']),
            position: position,
            infoWindow: InfoWindow(
              title: result['name'],
              snippet: result['vicinity'],
            ),
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
      // _currentPostition 있으면,
      mapController.moveCamera(
        // 카메라 이동
        CameraUpdate.newLatLng(_currentPosition!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 17.0,
              ),
              markers: Set<Marker>.of(_markers),
            ),
    );
  }
}
