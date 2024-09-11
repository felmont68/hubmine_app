import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfo extends ChangeNotifier {
  int _uid = 0;
  String _firstName = "";
  String _lastName = "";
  String password = "";
  String _phone = "";
  String _email = "";
  String _businessName = "";
  String _bussinessType = "";
  String _rfc = "";
  String _profilePhotoPath = "";
  int _userTypeId = 0;
  int _statusAccountId = 0;
  int _customerTypeID = 0;
  bool _isOnline = false;
  List cart = [];
  final int _itemsInCart = 0;
  bool _hasLoggedIn = false;

  String _hourDeliveryID = "";
  String get hourDeliveryID => _hourDeliveryID;

  set hourDeliveryID(String hourDeliveryID) {
    _hourDeliveryID = hourDeliveryID;
    notifyListeners();
  }

  DateTime _dateShipping = DateTime.now();
  String _timeShipping = DateFormat.jm().format(DateTime.now());

  String get timeShipping => _timeShipping;

  set timeShipping(String timeShipping) {
    _timeShipping = timeShipping;
    notifyListeners();
  }

  DateTime get dateShipping => _dateShipping;

  set dateShipping(DateTime dateShipping) {
    _dateShipping = dateShipping;
    notifyListeners();
  }

  bool get hasLoggedIn => _hasLoggedIn;

  set hasLoggedIn(bool hasLoggedIn) {
    _hasLoggedIn = hasLoggedIn;
    notifyListeners();
  }

  get isOnline => _isOnline;
  set isOnline(value) => _isOnline = value;

  get customerTypeID => _customerTypeID;
  set customerTypeID(value) => _customerTypeID = value;
  get uid => _uid;

  set uid(value) => _uid = value;

  get firstName => _firstName;

  set firstName(value) => _firstName = value;

  get lastName => _lastName;

  set lastName(value) => _lastName = value;

  get phone => _phone;

  set phone(value) => _phone = value;

  get email => _email;

  set email(value) => _email = value;

  get businessName => _businessName;

  set businessName(value) => _businessName = value;

  get bussinessType => _bussinessType;

  set bussinessType(value) => _bussinessType = value;

  get rfc => _rfc;

  set rfc(value) => _rfc = value;

  get userTypeId => _userTypeId;

  set userTypeId(value) => _userTypeId = value;

  get statusAccountId => _statusAccountId;

  set statusAccountId(value) => _statusAccountId = value;

  get profilePhotoPath => _profilePhotoPath;

  set profilePhotoPath(value) => _profilePhotoPath = value;

  get itemsInCart => _itemsInCart;

  set itemsInCart(value) => itemsInCart = value;

  String countryName = "";

  String countryCode = "";

  String countryFlag = "";
}
