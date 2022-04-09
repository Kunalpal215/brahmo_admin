import 'package:brahmo_admin/screens/home_screen.dart';
import 'package:brahmo_admin/screens/qr_scan/issued_item_info.dart';
import 'package:brahmo_admin/screens/qr_scan/scanner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        ScannerScreen.id : (context) => ScannerScreen(),
      },
    );
  }
}
