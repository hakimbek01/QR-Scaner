import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  Barcode? barcode;
  final qrKey=GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  bool code=false;
  double witdh=0;
  List<String> data =[];
  bool isFlash = false;

  @override
  void initState(){
    initial();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void initial() async {
    code=true;
    controller?.dispose();
    await Future.delayed(Duration(seconds: 1));
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Stack(
          alignment: Alignment.center,
          children: [
            buildQRView(),
            Align(
              alignment: Alignment.topCenter,
              child: MaterialButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  setState(() {
                    isFlash = !isFlash;
                    controller?.toggleFlash();
                  });
                },
                child: isFlash?Icon(CupertinoIcons.lightbulb_fill,color: Colors.yellow,):Icon(CupertinoIcons.lightbulb_slash_fill),
              ),
            ),
            Positioned(
              bottom: 20,
              child: buildResuld(),
            ),
          ],
        ),
      ),
    );
  }


  //builder QR scaner widgets
  //1
  Widget buildQRView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRView,
      overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width-80,
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          borderColor: Colors.blue
      ),
    );
  }



 //3
  Widget buildResuld() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width-40,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: Colors.white.withOpacity(.3),blurRadius: 7,spreadRadius: 2)
            ]
          ),
          child: Text(
            barcode!=null?"Natija: ${barcode!.code}":"Scaner kodi",
            maxLines: 2,
            style: TextStyle(color: Colors.black,overflow: TextOverflow.ellipsis),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: (){
            setState(() {
              Uri url=Uri.parse("${barcode!.code}");
              launchUrl(url);
              witdh+=15;
            });
          },
          minWidth: 200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Text("Open",style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
 //4
  void onQRView(QRViewController controller) {
    setState(() {
      this.controller=controller;
    });
    controller.scannedDataStream.listen((barcode)=>setState(() {
      this.barcode=barcode;
    }));
  }


}


