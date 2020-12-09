import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {

  final _serverIpController = TextEditingController();

  @override
  void dispose() {
    _serverIpController.dispose();
    super.dispose();
  }

  void _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      print(ip);
      setState(() {
        _serverIpController.text = ip;
      });
    } on Exception catch (_) {
      setState(() {
        _serverIpController.text = "";
      });
    }
  }

  Future<void> _saveIp(String ip) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("server_ip", ip);
      return ip;
    } on Exception catch (_) {
      return;
    }
  }

  @override
  void initState() {
    _getIp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        width: double.infinity,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "Server IP",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              alignment: Alignment.center,
              child: TextField(
                controller: _serverIpController,
                textAlign: TextAlign.center,
                cursorColor: Theme.of(context).accentColor,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: RaisedButton(
                child: Text(
                  "Save",
                ),
                onPressed: () async {
                  await this._saveIp(this._serverIpController.text);
                  Navigator.of(context).pushReplacementNamed("/home_screen");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
