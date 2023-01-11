import 'package:flutter/material.dart';
import 'package:qrcodescaner/service/prefs_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlData extends StatefulWidget {

  final List<String> urlData;

  const UrlData({Key? key, required this.urlData}) : super(key: key);

  @override
  State<UrlData> createState() => _UrlDataState();
}

class _UrlDataState extends State<UrlData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jurnal"),
        actions: [
          IconButton(
            onPressed: (){
              removeListUrl();
              setState(() {
                widget.urlData.clear();
              });
            },
            icon: Icon(Icons.clear_all,size: 33,),
          )
        ],
        backgroundColor: Colors.grey.shade600,
      ),
      body: SafeArea(
        child: ListView(
          children: widget.urlData.map((e) {
            return _itemOfDataUrl(e);
          }).toList()),
        ),
    );
  }

  Widget _itemOfDataUrl(String str) {
    return MaterialButton(
      onPressed: (){
        setState(() {
          Uri url=Uri.parse(str);
          launchUrl(url);
        });
      },
      padding: EdgeInsets.zero,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.width/5,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(color: Colors.grey,offset: Offset(0,1),blurRadius: 3)
              ]
          ),
          child: Text('URL: $str',maxLines: 3,style: TextStyle(overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),)
      ),
    );
  }


  void removeListUrl() {
    PrefsService.removeData();
  }
}
