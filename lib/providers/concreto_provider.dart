import 'package:flutter/material.dart';

class ConcretoInfo extends ChangeNotifier {
  String _usoConcreto = "";

  String get usoConcreto => _usoConcreto;

  set usoConcreto(String usoConcreto) {
    _usoConcreto = usoConcreto;
    notifyListeners();
  }

  String _tipoColado = "";

  String get tipoColado => _tipoColado;

  set tipoColado(String tipoColado) {
    _tipoColado = tipoColado;
    notifyListeners();
  }

  String _tipoConcreto = "";

  String get tipoConcreto => _tipoConcreto;

  set tipoConcreto(String tipoConcreto) {
    _tipoConcreto = tipoConcreto;
    notifyListeners();
  }

  String _concreteID = "";

  String get concreteID => _concreteID;

  set concreteID(String concreteID) {
    _concreteID = concreteID;
    notifyListeners();
  }

  String _contactName = "";

  String get contactName => _contactName;

  set contactName(String contactName) {
    _contactName = contactName;
    notifyListeners();
  }

  String _contactPhone = "";

  String get contactPhone => _contactPhone;

  set contactPhone(String contactPhone) {
    _contactPhone = contactPhone;
    notifyListeners();
  }

  String _contactEmail = "";

  String get contactEmail => _contactEmail;

  set contactEmail(String contactEmail) {
    _contactEmail = contactEmail;
    notifyListeners();
  }

  String _dateDelivery = "";

  String get dateDelivery => _dateDelivery;

  set dateDelivery(String dateDelivery) {
    _dateDelivery = dateDelivery;
    notifyListeners();
  }

  String _hourDeliveryID = "";

  String get hourDeliveryID => _hourDeliveryID;

  set hourDeliveryID(String hourDeliveryID) {
    _hourDeliveryID = hourDeliveryID;
    notifyListeners();
  }

  String _cuantity = "";

  String get cuantity => _cuantity;

  set cuantity(String cuantity) {
    _cuantity = cuantity;
    notifyListeners();
  }

  String _cuantityByTruck = "";

  String get cuantityByTruck => _cuantityByTruck;

  set cuantityByTruck(String cuantityByTruck) {
    _cuantityByTruck = cuantityByTruck;
    notifyListeners();
  }

  String _numberOfTrucks = "";

  String get numberOfTrucks => _numberOfTrucks;

  set numberOfTrucks(String numberOfTrucks) {
    _numberOfTrucks = numberOfTrucks;
    notifyListeners();
  }

  String _timeBTID = "";

  String get timeBTID => _timeBTID;

  set timeBTID(String timeBTID) {
    _timeBTID = timeBTID;
    notifyListeners();
  }

  List _addons = [];

  List get addons => _addons;

  set addons(List addons) {
    _addons = addons;
    notifyListeners();
  }
}
