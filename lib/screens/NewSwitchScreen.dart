import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/NewSwitchValidator.dart';

class NewSwitchScreen extends StatefulWidget {
  static const routeName = "/new_switch_screen";

  @override
  _NewSwitchScreenState createState() => _NewSwitchScreenState();
}

class _NewSwitchScreenState extends State<NewSwitchScreen> {
  String _newPin;

  String _newName = "";

  bool _isLoaded = false;

  var _data;

  Future<dynamic> _doNothing() async {
    return _data;
  }

  Future<String> _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      return ip;
    } on Exception catch (_) {
      return "";
    }
  }

  Future<dynamic> _loadPins() async {
    String ip = await _getIp();
    http.Response pinsResponse = await http.get(
      "http://" + ip + ":3000/get_pins",
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    );
    if (pinsResponse.statusCode != 200) {
      return null;
    }
    List pins = json.decode(pinsResponse.body);

    http.Response switchesResponse = await http.get(
      "http://" + ip + ":3000/get_switches",
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    );
    if (switchesResponse.statusCode != 200) {
      return null;
    }
    List switches = jsonDecode(switchesResponse.body);

    switches.forEach((sw) {
      pins.remove(sw["pin"]);
    });
    this._newPin = pins[0].toString();
    _isLoaded = true;
    _data = pins;
    return pins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Add switch"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _isLoaded ? _doNothing() : _loadPins(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          onChanged: (txt) {
                            setState(() {
                              this._newName = txt;
                            });
                          },
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Pin:",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                          ),
                          onChanged: (newVal) {
                            setState(() {
                              this._newPin = newVal;
                            });
                          },
                          items: snapshot.data
                              .map<DropdownMenuItem<String>>((val) {
                            return DropdownMenuItem(
                              value: val.toString(),
                              child: Text(val.toString()),
                            );
                          }).toList(),
                          value: this._newPin,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("error"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          bool result = await NewSwitchValidator().uploadPin(this._newName, this._newPin);
          if(result) {
            Navigator.of(context).pushReplacementNamed("/home_screen");
          }
        },
        child: Icon(
          Icons.save,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
