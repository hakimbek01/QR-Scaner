
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:torch_light/torch_light.dart';
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
  bool isLamp=false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async{
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Stack(
          alignment: Alignment.center,
          children: [
            buildQRView(),
            Positioned(
              top: 20,
              child: buildLamp(),
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

  Widget buildLamp() {
    return MaterialButton(
      onPressed: (){
        setState(() {
          isLamp=!isLamp;
          isLamp?TorchLight.enableTorch():TorchLight.disableTorch();
        });
      },
      padding: EdgeInsets.zero,
      minWidth: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        color: Colors.white30,
        child: isLamp?Icon(Icons.flash_on,color: Colors.yellow):Icon(Icons.flash_off,color: Colors.grey,),
      ),
    );
  }

  Widget buildResuld() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width-40,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text(
            barcode!=null?"Natija: ${barcode!.code}":"Scaner kodi",
            maxLines: 2,
            style: TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: (){
            setState(() {
              Uri url=Uri.parse("https://www.google.com/search?q=qr+codes&sxsrf=AJOqlzWFN7GU1aoW3Vxjuz-b_fZzEzQesA:1673266921736&source=lnms&tbm=isch&sa=X&ved=2ahUKEwih3--Dvbr8AhXxlosKHQb0CBgQ_AUoAXoECAEQAw&biw=1366&bih=625&dpr=1#imgrc=tyIRyD8TqAYw_M");
              launchUrl(url);
            });
          },
          minWidth: 200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white30,
          child: Text("Open"),
        )
      ],
    );
  }

  void onQRView(QRViewController controller) {
    setState(() {
      this.controller=controller;
    });
    controller.scannedDataStream.listen((barcode)=>setState(() {
      this.barcode=barcode;
    }));
  }
}
