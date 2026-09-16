import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  final RxBool isConnected = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    // Check immediately when app starts
    checkInternetConnection();

    // Check when Wi-Fi / mobile network changes
    _subscription =
        _connectivity.onConnectivityChanged.listen((results) async {
          await checkInternetConnection();
        });

    // Check real internet every 3 seconds
    _timer = Timer.periodic(
      const Duration(seconds: 3),
          (_) async {
        await checkInternetConnection();
      },
    );
  }

  Future<void> checkInternetConnection() async {
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup(
        'flutter-api.janrent.com',
      ).timeout(
        const Duration(seconds: 5),
      );

      if (result.isNotEmpty &&
          result.first.rawAddress.isNotEmpty) {
        isConnected.value = true;
      } else {
        isConnected.value = false;
      }
    } catch (e) {
      isConnected.value = false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }
}