import 'package:mining_solutions/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverServiceStorage {
  static saveDataUser(User user) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', user.token);
    await _prefs.setInt('idUser', user.idUser);
    await _prefs.setInt('typeUser', user.typeUser);
    await _prefs.setString('firstName', user.firstName);
    await _prefs.setString('lastName', user.lastName);
    await _prefs.setString('email', user.email);
    await _prefs.setString("profilePhoto", user.profilePhoto);
    return true;
  }

  static getIdUser() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('idUser');
  }

  static getUserTypeId() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('typeUser');
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

  static saveOnlineStatus(option) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("isDriverOnline", option);
  }

  static getOnlineStatus() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool("isDriverOnline") ?? false;
  }
}
