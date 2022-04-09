import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class IssuedItemInfo extends StatefulWidget {
  final String itemName;
  final int itemQuantity;
  final String personEmail;
  final String username;
  IssuedItemInfo({required this.itemName,required this.itemQuantity, required this.personEmail,required this.username});
  @override
  State<IssuedItemInfo> createState() => _IssuedItemInfoState();
}

class _IssuedItemInfoState extends State<IssuedItemInfo> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: screenWidth,),
          Text(widget.username),
          Text(widget.personEmail.toString()),
          Text(widget.itemName),
          Text("Quantity booked : " + widget.itemQuantity.toString()),
        ],
      ),
    );
  }
}
