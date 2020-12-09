class LightSwitch {

  String _name;
  bool _state;

  LightSwitch(String name, bool state) {
    this._name = name;
    this._state = state;
  }

  String getName() {
    return this._name;
  }

  bool getState() {
    return this._state;
  }
}