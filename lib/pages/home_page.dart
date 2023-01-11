import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcodescaner/pages/data_url_page.dart';
import 'package:qrcodescaner/service/prefs_service.dart';
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
  Timer? timer;
  double witdh=0;
  List<String> data =[];


  @override
  void initState() {
    code=true;
    controller?.dispose();
    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      controller?.resumeCamera();
      timer.cancel();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
              child: Row(
                children: [
                  buildGalery(),
                  SizedBox(width: 15,),
                  buildDataPageButton()
                ],
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
 //2
  Widget buildGalery() {
    return MaterialButton(
      onPressed: (){},
      padding: EdgeInsets.zero,
      minWidth: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        color: Colors.white30,
        child: Icon(CupertinoIcons.photo_fill,color: Colors.white,)
      ),
    );
  }

  Widget buildDataPageButton() {
    return  MaterialButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UrlData(urlData: data),));
      },
      padding: EdgeInsets.zero,
      minWidth: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      clipBehavior: Clip.hardEdge,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          color: Colors.white30,
          child: Icon(CupertinoIcons.calendar_today,color: Colors.white,)
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
            funk();
            setState(() {
              Uri url=Uri.parse("${barcode!.code}");
              launchUrl(url);
              witdh+=15;
            });
          },
          minWidth: 200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white30,
          child: Text("Open",style: TextStyle(color: Colors.white),),
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


  //data url save func
  void funk (){
    if (barcode?.code != null && !(data.contains((barcode?.code).toString()))) {
      data.add((barcode?.code).toString());
    }
    PrefsService.storeData(data);
    PrefsService.loadData().then((value) => {
      print(value)
    });
  }
}


