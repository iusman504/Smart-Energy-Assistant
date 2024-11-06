import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/notification_services.dart';

class HomeProvider with ChangeNotifier{
double _voltage = 0;
double _current = 0;
double _humidity = 0;
double _temperature = 0;

double get voltage => _voltage;
double get current => _current;
double get humidity => _humidity;
double get temperature => _temperature;

bool showVoltage = true;
bool showCurrent = false;
bool showHumidity = false;
bool showTemp = false;

List<FlSpot> voltageData = [];
List<FlSpot> currentData = [];
List<FlSpot> humidityData = [];
List<FlSpot> tempData = [];

NotificationServices notificationServices = NotificationServices();

void fetchValues() {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  _listenToValueChanges(dbRef.child('voltage'), (value) {
      _voltage = value;
      notifyListeners();
    _checkVoltage();
  });

  _listenToValueChanges(dbRef.child('current'), (value) {
    _current = value;
    notifyListeners();
  });

  _listenToValueChanges(dbRef.child('humidity'), (value) {
    _humidity = value;
    notifyListeners();
  });

  _listenToValueChanges(dbRef.child('temp'), (value) {
    _temperature = value;
    notifyListeners();
    _checkTemperature();
  });
}

void _listenToValueChanges(
    DatabaseReference ref, Function(dynamic) onChange) {
  ref.onValue.listen((event) {
    final newValue = event.snapshot.value;
    print('New value from database: $newValue');
    onChange(newValue);
  });
}

void _checkTemperature() {
  if (_temperature >= 50) {
    notificationServices.showNotification(
      title: 'High Temperature Alert',
      body: 'The temperature is above 50!',
    );
  }
}

void _checkVoltage() {
  if (_voltage >= 250) {
    notificationServices.showNotification(
      title: 'High Voltage Alert',
      body: 'The Voltage is above 250!',
    );
  }
}

void updateData() {
  if (showVoltage) {
    // Assuming 'voltage' is the fetched variable holding the voltage value as a double
    final value = _voltage;
    // print(value);
    voltageData.add(FlSpot(
      DateTime.now().millisecondsSinceEpoch.toDouble(),
      value, // Directly use the value (no need to convert)
    ));
    _saveData();
    notifyListeners(); // Notify listeners after updating the data
  }

  if (showCurrent) {
    // Assuming 'current' is the fetched variable holding the current value as a double
    final value = _current;
    // print(value);
    currentData.add(FlSpot(
      DateTime.now().millisecondsSinceEpoch.toDouble(),
      value, // Directly use the value (no need to convert)
    ));
    _saveData();
    notifyListeners(); // Notify listeners after updating the data
  }

  if (showHumidity) {
    // Assuming 'humidity' is the fetched variable holding the power value as a double
    final value = _humidity;
    // print(value);
    humidityData.add(FlSpot(
      DateTime.now().millisecondsSinceEpoch.toDouble(),
      value, // Directly use the value (no need to convert)
    ));
    _saveData();
    notifyListeners(); // Notify listeners after updating the data
  }

  if (showTemp) {
    // Assuming 'temp' is the fetched variable holding the temperature value as a double
    final value = _temperature;
    // print(value);
    tempData.add(FlSpot(
      DateTime.now().millisecondsSinceEpoch.toDouble(),
      value, // Directly use the value (no need to convert)
    ));
    _saveData();
    notifyListeners(); // Notify listeners after updating the data
  }
}

Future<void> _saveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('voltageData', _convertDataToString(voltageData));
  prefs.setStringList('currentData', _convertDataToString(currentData));
  prefs.setStringList('powerData', _convertDataToString(humidityData));
  prefs.setStringList('tempData', _convertDataToString(tempData));
}

List<String> _convertDataToString(List<FlSpot> data) {
  return data.map((e) => '${e.x},${e.y}').toList();
}

Future<void> loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    voltageData = _getDataFromPrefs(prefs, 'voltageData');
    currentData = _getDataFromPrefs(prefs, 'currentData');
    humidityData = _getDataFromPrefs(prefs, 'powerData');
    tempData = _getDataFromPrefs(prefs, 'tempData');
  notifyListeners();
}

List<FlSpot> _getDataFromPrefs(SharedPreferences prefs, String key) {
  List<String>? dataString = prefs.getStringList(key);
  if (dataString == null) return [];
  return dataString.map((e) {
    var split = e.split(',');
    return FlSpot(double.parse(split[0]), double.parse(split[1]));
  }).toList();
}

void showVoltageData(value) {
    showVoltage = value ?? true;
    showCurrent = false;
    showHumidity = false;
    showTemp = false;
    notifyListeners();
     updateData();
}

void showCurrentData(value) {
    showCurrent = value ?? true;
    showVoltage = false;
    showHumidity = false;
    showTemp = false;
    notifyListeners();
     updateData();
}

void showHumidityData(value) {
  showHumidity = value ?? true;
  showCurrent = false;
  showVoltage = false;
  showTemp = false;
  notifyListeners();
  updateData();
}

void showTempData(value) {
  showTemp = value ?? true;
  showVoltage = false;
  showHumidity = false;
  showVoltage = false;
  notifyListeners();
  updateData();
}

LineChartBarData buildLineChartBarData(List<FlSpot> data, Color color) {
  return LineChartBarData(
    spots: data,
    isCurved: false,
    color: color,
    barWidth: 2,
    isStrokeCapRound: true,
    belowBarData: BarAreaData(show: true),
    dotData: const FlDotData(show: false),
  );
}


}