// ملف offline_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineService {
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<bool> get connectionStream {
    return Connectivity().onConnectivityChanged.map((result) => result != ConnectivityResult.none);
  }
}