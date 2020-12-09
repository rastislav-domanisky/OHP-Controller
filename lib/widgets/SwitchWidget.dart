import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SwitchWidget extends StatefulWidget {
  final String _name;
  final bool _state;
  final int _index;

  SwitchWidget(this._name, this._state, this._index);

  @override
  _SwitchWidgetState createState() =>
      _SwitchWidgetState(this._name, this._state, this._index);
}

class _SwitchWidgetState extends State<SwitchWidget> {
  String _name;
  bool _state;
  int _index;

  _SwitchWidgetState(String name, bool state, int index) {
    this._name = name;
    this._state = state;
    this._index = index;
  }

  bool _isSwitched = false;

  Future<String> _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      return ip;
    } on Exception catch (_) {
      return "";
    }
  }

  Future<bool> _toggleSwitch(bool newState) async {
    setState(() {
      this._isSwitched = true;
    });
    var queryParameters = {
      'index': this._index.toString(),
      'state': newState.toString(),
    };
    var uri = Uri(queryParameters: queryParameters).query;
    final bool result = await http.post(
      "http://" + await _getIp() + ":3000/switch?" + uri,
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    ).then((value) {
      if (value.statusCode == 200) {
        return !this._state;
      } else {
        return this._state;
      }
    }).catchError((e) {
      print(e);
      setState(() {
        this._isSwitched = false;
      });
      return this._state;
    });
    setState(() {
      this._isSwitched = false;
    });
    return result;
  }

  Future<bool> _deleteSwitch() async {
    var queryParameters = {
      'index': this._index.toString(),
    };
    var uri = Uri(queryParameters: queryParameters).query;
    String ip = await _getIp();
    final bool result = await http.post(
      "http://" + ip + ":3000/delete_switch?" + uri,
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    ).then((value) {
      if (value.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      print(e);
      return false;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 20,
              ),
              child: Text(
                this._name,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Switch(
                    value: this._state,
                    onChanged: (val) async {
                      if(this._isSwitched) {
                        return;
                      }
                      bool x = await _toggleSwitch(val);
                      setState(() {
                        this._state = x;
                      });
                    },
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () async {
                        bool x = await _deleteSwitch();
                        if(x) {
                          Navigator.of(context).pushReplacementNamed("/home_screen");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
