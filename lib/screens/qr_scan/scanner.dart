import 'dart:io';

import 'package:brahmo_admin/screens/qr_scan/issued_item_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class ScannerScreen extends StatefulWidget {
  static const id = "/qrScanner";
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  Barcode? barcodeDetected;
  bool allotmentStarted = false;

  void onQRViewCreated(QRViewController controller){
    String lastCode = "";
    controller.scannedDataStream.listen((barcode) async {
      String itemID = "";
      int quantity = 0;
      String email = "";
      String itemName = "";
      String username = "";
      String? code = barcode.code;
      if(code!=null && lastCode!=code && allotmentStarted==false){
        allotmentStarted=true;
        lastCode=code;
        int first = code.indexOf("/");
        int second = -1;
        int third = -1;
        int fourth = -1;
        if(first!=-1){
          String next = code.substring(first+1);
          // print(next);
          second = first + 1 + next.indexOf("/");
          // print(second);
        }
        if(first!=-1 && second!=-1){
          String next = code.substring(second+1);
          third = second+1+next.indexOf("/");
        }
        if(first!=-1 && second!=-1 && third!=-1){
          String next = code.substring(third+1);
          fourth = third+1+next.indexOf("/");
        }
        if(first!=-1 && second!=-1 && third!=-1 && fourth!=-1){
          print(first.toString() + " " + second.toString() + " " + third.toString());
          print("allotmentStarted");
          itemID = code.substring(0,first);
          print(itemID);
          print(code.substring(first+1,first+2));
          print(code.substring(second+1));
          quantity = int.parse(code.substring(first+1,second));
          email = code.substring(second+1,third);
          itemName = code.substring(third+1,fourth);
          username = code.substring(fourth+1);
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(email).get();
          if(userSnapshot.get("have_issued")==true){
            if(await Vibrate.canVibrate){
              Vibrate.vibrate();
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Already some item issued to this person")));
            allotmentStarted=false;
            first=-1;
            second=-1;
            third=-1;
            fourth=-1;
          }
          bool success = true;
          print(itemID);
          print(quantity);
          print(email);
          print(itemName);
          print(username);
          await FirebaseFirestore.instance.runTransaction(
                  (transaction) async {
                    DocumentReference postRef = FirebaseFirestore.instance.collection('sports_items').doc(itemID);
                    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('sports_items').doc(itemID).get();
                    int afterRes = 0;
                    if(documentSnapshot.get("available")-quantity >=0){
                      print("YES 1");
                      afterRes = documentSnapshot.get("available")-quantity;
                    }
                    else{
                      print("YES 2");
                      success=false;
                    }
                    if(success==true){
                      print("YES 3");
                      transaction.update(postRef, {"available" : afterRes});
                      List resHistoryArray = userSnapshot.get("issue_history");
                      resHistoryArray.add({"itemName" : itemName, "itemID" : itemID, "quantity" : quantity});
                      await FirebaseFirestore.instance.collection('users').doc(email).update({"currently_issued" : {"item_id" : itemID, "quantity" : quantity, "name" : itemName},"have_issued" : true,"issue_history" : resHistoryArray});
                    }
                    else{
                      return;
                    }
          });
          if(success==true){
            if(await Vibrate.canVibrate){
              Vibrate.vibrate();
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item was succesfully allocated :)")));
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => IssuedItemInfo(itemName: itemName, itemQuantity: quantity, personEmail: email, username: username,)));
            print("Wollah Success !");
          }
          else{
            if(await Vibrate.canVibrate){
              Vibrate.vibrate();
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${quantity} quantity of ${itemName} is not available")));
            allotmentStarted=false;
            first=-1;
            second=-1;
            third=-1;
            fourth=-1;
            print("Bad Luck :(");
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    qrController?.dispose();
  }

  @override
  void reassemble(){
    super.reassemble();
    if(Platform.isAndroid){
      qrController!.pauseCamera();
    }
    else{
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QRView(
          key: qrKey,
          onQRViewCreated: onQRViewCreated,
        ),
      )
    );
  }
}
