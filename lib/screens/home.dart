import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 위치 관련 모든 작업을 처리하는 서비스
  final LocationService _locationService = LocationService();
  Position? _position; // 검색 후 사용자의 현재 위치를 유지
  String? _error; 

  Future<void> _loadLocation() async {
    // 장치의 현재 GPS 위치를 검색하고 상태 업데이트
    setState(() {
      _error = null; //이전 오류 삭제
    });
    try { // 서비스에서 현재 위치 요청
      final pos = await _locationService.getCurrentPosition();
      setState(() {
        _position = pos;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ //현재 위치 가져오고 싶으면 탭
            ElevatedButton(
              onPressed: _loadLocation,
              child: const Text('현재 위치 가져오기'),
            ),
            const SizedBox(height: 20),

            // 좌표가 사용 가능할 때 표시
            if (_position != null)
              Text('위도: ${_position!.latitude}, 경도: ${_position!.longitude}'),
            if (_error != null) //에러
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
