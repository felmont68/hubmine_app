import 'package:mining_solutions/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceStorage {
  static saveDataUser(User user) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', user.token);
    await _prefs.setInt('idUser', user.idUser);
    await _prefs.setInt('typeUser', user.typeUser);
    await _prefs.setString('firstName', user.firstName);
    await _prefs.setString('lastName', user.lastName);
    await _prefs.setString('email', user.email);
    await _prefs.setString("profilePhoto", user.profilePhoto);
    await _prefs.setInt("customerTypeID", user.customerTypeID);
    await _prefs.setBool("isDriverOnline", true);
    await _prefs.setBool("hasLoggedIn", true);
    return true;
  }

  static getHasLoggedIn() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('hasLoggedIn');
  }

  static saveHasLoggedIn(option) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("hasLoggedIn", option);
  }

  static getIdUser() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('idUser');
  }

  static getUserTypeId() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('typeUser');
  }

  static getCustomerTypeID() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('customerTypeID');
  }

  static getToken() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }

  static getEmail() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('email');
  }

  static clearSharedPreferences() async {
    print("Limpiando shared_preferences");
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
    return true;
  }

  static saveNotificationsPreferences(option) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("receiveNotifications", option);
  }

  static getNotificationsPreferences() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('receiveNotifications');
  }

  static saveCodeLanguage(option) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("languageCode", option);
  }

  static saveCountryCode(option) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("countryCode", option);
  }

  static getCountryCode() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('countryCode');
  }
}