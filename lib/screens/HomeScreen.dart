import 'package:flutter/material.dart';

import '../widgets/CurrentTempWidget.dart';
import '../widgets/SwitchesWidget.dart';
import '../widgets/SettingsWidget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  List<Widget> _list = <Widget>[
    ListView(
      children: <Widget>[
        CurrentTempWidget(),
      ],
    ),
    SwitchesWidget(),
    SettingsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      this._index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: Text("Open Home Panel"),
        actions: [
          _index == 1
              ? IconButton(
            icon: Icon(
              Icons.add,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/new_switch_screen");
            },
          )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: _list[this._index],
        ),
      ),
      backgroundColor: Theme
          .of(context)
          .canvasColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toggle_on_outlined),
            label: 'Switches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme
            .of(context)
            .accentColor,
        unselectedItemColor: Theme
            .of(context)
            .accentColor
            .withOpacity(0.5),
        currentIndex: this._index,
        onTap: this._onItemTapped,
      ),
    );
  }
}
