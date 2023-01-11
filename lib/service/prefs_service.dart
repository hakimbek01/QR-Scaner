// import 'package:qrcodescaner/service/data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrefsService {

  static storeData(List<String> data) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.setStringList('data', data);
  }

  static Future<List?>loadData() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getStringList('data');
  }

  static Future<bool> removeData() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.remove('data');
  }
}



