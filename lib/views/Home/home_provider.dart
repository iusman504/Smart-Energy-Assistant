import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

}