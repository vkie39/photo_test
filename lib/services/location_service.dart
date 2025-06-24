import 'package:geolocator/geolocator.dart';

//위치 api 연결
class LocationService {
  // 권한이 부여되지 않았거나 서비스가 비활성화된 경우 현재 장치 위치를 반환하거나 오류 메시지를 표시합니다.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('GPS 비활성화됨');
    }

    //권환 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한 거부됨');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한 영구 거부됨');
    }

    return Geolocator.getCurrentPosition();
  }
}
