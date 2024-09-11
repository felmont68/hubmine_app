import 'package:flutter/widgets.dart';

class LocationProvider extends ChangeNotifier {
  int _iDLocationSelected = 0;
  double _latitude = 0.0, _longitude = 0.0;
  String _addressComplete = "";
  String _streetName = '',
      _colName = '',
      _postalCode = '',
      _city = '',
      _edo = '';

  void setAddressComplete(String address) {
    _addressComplete = address;
    notifyListeners();
  }

  void setiDLocationSelected(int id) {
    _iDLocationSelected = id;
    notifyListeners();
  }

  void setCurrentLatitude(double lt) {
    _latitude = lt;
    notifyListeners();
  }

  void setCurrentLongitude(double lt) {
    _longitude = lt;
    notifyListeners();
  }

  void setStreetName(String n) {
    _streetName = '';
    _streetName = n;
    notifyListeners();
  }

  void setCityName(String n) {
    _city = '';
    _city = n;
    notifyListeners();
  }

  void setColName(String n) {
    _colName = '';
    _colName = n;
    notifyListeners();
  }

  void setPostalCode(String n) {
    _postalCode = '';
    _postalCode = n;
    notifyListeners();
  }

  void setStateName(String n) {
    _edo = '';
    _edo = n;
    notifyListeners();
  }

  String get nameStreet {
    return _streetName;
  }

  String get city {
    return _city;
  }

  String get edo {
    return _edo;
  }

  String get colName {
    return _colName;
  }

  String get postalCode {
    return _postalCode;
  }

  double get getCurrentLatituded {
    return _latitude;
  }

  double get getCurrentLongitude {
    return _longitude;
  }

  int get iDLocationSelected {
    return _iDLocationSelected;
  }

  String get addressComplete {
    return _addressComplete;
  }
}
