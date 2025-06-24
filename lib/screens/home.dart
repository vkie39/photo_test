import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();
  Position? _position;
  String? _error;

  Future<void> _loadLocation() async {
    setState(() {
      _error = null;
    });
    try {
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
          children: [
            ElevatedButton(
              onPressed: _loadLocation,
              child: const Text('현재 위치 가져오기'),
            ),
            const SizedBox(height: 20),
            if (_position != null)
              Text('위도: ${_position!.latitude}, 경도: ${_position!.longitude}'),
            if (_error != null)
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
