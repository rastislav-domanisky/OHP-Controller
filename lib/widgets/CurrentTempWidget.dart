import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrentTempWidget extends StatefulWidget {
  @override
  _CurrentTempWidgetState createState() => _CurrentTempWidgetState();
}

class _CurrentTempWidgetState extends State<CurrentTempWidget> {

  Future<String> _getIp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ip = prefs.getString("server_ip");
      return ip;
    } on Exception catch (_) {
      return "";
    }
  }

  Future<String> _getTemp() async {
    String ip = await _getIp();
    final response = await http.get(
      "http://" + ip + ":3000/get_temp",
      headers: {
        "API-KEY": "openhomepanel123",
        "Content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Temperature",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future: _getTemp(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
