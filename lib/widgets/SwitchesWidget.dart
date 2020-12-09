import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/LightSwitch.dart';
import '../widgets/SwitchWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchesWidget extends StatefulWidget {
  @override
  _SwitchesWidgetState createState() => _SwitchesWidgetState();
}

class _SwitchesWidgetState extends State<SwitchesWidget> {

  Future<String> _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      return ip;
    } on Exception catch (_) {
      return "";
    }
  }

  List<LightSwitch> _switches = List<LightSwitch>();

  Future<void> _loadSwitches() async {
    this._switches.clear();
    String ip = await _getIp();
    final response = await http.get(
      "http://" + ip + ":3000/get_switches",
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    );
    List swList = json.decode(response.body);
    for (int i = 0; i < swList.length; i++) {
      setState(() {
        this._switches.add(LightSwitch(swList[i]["name"], swList[i]["state"]));
      });
    }
  }

  @override
  void initState() {
    _loadSwitches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      onRefresh: _loadSwitches,
      child: ListView.builder(
        itemCount: this._switches.length,
        itemBuilder: (context, index) {
          return SwitchWidget(
            _switches[index].getName(),
            _switches[index].getState(),
            index,
          );
        },
      ),
    );
  }
}
