import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewSwitchValidator {

  Future<String> _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      return ip;
    } on Exception catch (_) {
      return "";
    }
  }

  Future<bool> uploadPin(String name, String pinText) async {
    int pin = int.parse(pinText);
    String ip = await _getIp();
    var queryParameters = {
      'name': name.trim(),
      'pin': pin.toString(),
    };
    var uri = Uri(queryParameters: queryParameters).query;
    final http.Response result = await http.post(
      "http://" + ip + ":3000/add_switch?" + uri,
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    );
    if(result.statusCode != 200) {
      return false;
    }
    return true;
  }
}
