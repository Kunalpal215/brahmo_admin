import 'package:brahmo_admin/screens/qr_scan/scanner.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ScannerScreen.id);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            color: Colors.yellow,
            child: Text("Scan a QR"),
          ),
        ),
      ),
    );
  }
}
