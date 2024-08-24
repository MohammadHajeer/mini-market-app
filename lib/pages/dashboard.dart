import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mini_market_app/models/product.dart';
import 'dart:async';

import 'package:mini_market_app/services/database_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final player = AudioPlayer();
  Timer? _throttleTimer;
  DateTime _lastScanTime = DateTime.now().subtract(const Duration(seconds: 1));
  final DatabaseService _databaseService = DatabaseService.instance;
  double money = 0;

  @override
  void dispose() {
    player.dispose();
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            money.toString(),
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              FlutterBarcodeScanner.getBarcodeStreamReceiver(
                      "#ff6666", "Cancel", false, ScanMode.BARCODE)
                  ?.listen((barcode) async {
                final currentTime = DateTime.now();
                final timeSinceLastScan = currentTime.difference(_lastScanTime);

                if (timeSinceLastScan.inSeconds >= 1) {
                  _lastScanTime = currentTime;

                  if (barcode is String && barcode.length > 5) {
                    await player.play(AssetSource("beep.mp3"));
                    ProductModel? product = await _databaseService.getProduct(barcode) ;
                    print("BARCODEEEEEEEEEEEE $barcode, price: ${product != null ? product.price : "not found"}");
                    if(product != null) {
                      setState(() {
                        money += product.price;
                      });
                    }
                  }

                  _throttleTimer?.cancel();
                  _throttleTimer = Timer(const Duration(seconds: 1), () {});
                }
              });
            },
            child: const Text("PRESS TO PLAY"),
          ),
        ],
      ),
    );
  }
}
