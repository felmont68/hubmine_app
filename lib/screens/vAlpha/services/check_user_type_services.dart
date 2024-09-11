import 'package:mining_solutions/demo/screens/home.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';
import 'package:mining_solutions/services/storage_services.dart';

class CheckUserTypeServices {
  static loadUserType() async {
    bool isAdmin = false;

    var userType = await ServiceStorage.getUserTypeId();

    if (userType == 1) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    return isAdmin;
  }

  static loadIsDriver() async {
    bool isDriver = false;
    var customerTypeID = await ServiceStorage.getCustomerTypeID();

    if (customerTypeID == 3) {
      isDriver = true;
    } else {
      isDriver = false;
    }

    return isDriver;
  }

  static loadHomePage() async {
    var isAdmin = await loadUserType();
    var isDriver = await loadIsDriver();

    if (isDriver) {
      if (isAdmin) {
        return const HomeDriver();
      } else {
        return const HomePageAlpha();
      }
    } else {
      return const HomePage();
    }
  }
}
