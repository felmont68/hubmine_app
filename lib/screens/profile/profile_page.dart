import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/screens/profile/widgets/profile_avatar.dart';
import 'package:mining_solutions/screens/profile/widgets/setting_component.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? reloadState;
  const ProfilePage({Key? key, this.reloadState}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final List settingsList = [
    {
      "title": "Notificaciones",
      "icon": SvgPicture.asset("assets/notification.svg", color: primaryClr),
      "route": "notifications"
    },
    {
      "title": "Recompensas",
      "icon": SvgPicture.asset("assets/award.svg", color: primaryClr),
      "route": "rewards"
    },
    {
      "title": "Configuraciones",
      "icon": SvgPicture.asset("assets/settings.svg", color: primaryClr),
      "route": "settings"
    },
    {
      "title": "Centro de ayuda",
      "icon": SvgPicture.asset("assets/headphone.svg", color: primaryClr),
      "route": "help"
    },
    {
      "title": "Sobre Hubmine",
      "icon": SvgPicture.asset("assets/hubmine.svg"),
      "route": "about"
    }
  ];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> storeUserCredentials(String tokenhuella) async {
    await _storage.write(key: 'tokenhuella', value: tokenhuella);
  }

  Future<void> authenticateWithBiometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Autentifíquese con su biometría',
        stickyAuth: true,
      );

      if (authenticated) {
        var token = await ServiceStorage.getToken();

        await storeUserCredentials(token.toString());
        EasyLoading.showSuccess("Biometría guardada.",
            duration: const Duration(milliseconds: 4000));
      } else {
        EasyLoading.showError("Autenticación fallida.",
            duration: const Duration(milliseconds: 4000));
      }
    } on PlatformException catch (e) {
      print(e);
      EasyLoading.showError("Biometría no registrada. Por favor, registrela.",
          duration: const Duration(milliseconds: 4000));
      OpenSettings.openBiometricEnrollSetting();
      var token = await ServiceStorage.getToken();
      print('Token leído: $token');
      await _storage.write(key: 'tokenhuella', value: token);
      await storeUserCredentials(token.toString());
      EasyLoading.showSuccess("Biometría guardada.",
          duration: const Duration(milliseconds: 4000));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Mi perfil", style: subHeading1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        child: Column(
          children: [
            const ProfileAvatar(),
            const SizedBox(height: 12),
            Text(
                "${userInfo.firstName.split(' ').first} ${userInfo.lastName.split(' ').first}",
                style: heading),
            Text("${userInfo.businessName}", style: bodyGray60),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: ButtonSide(
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.face,
                    color: primaryClr,
                  ),
                ),
                color: Colors.white,
                action: () async {
                  await authenticateWithBiometrics(context);
                },
                height: MediaQuery.of(context).size.height * 0.047,
                text: Text(
                  "Agregar Biometría",
                  style: subHeading2PrimaryClr,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...[...renderSettings()],
            Button(
              color: accentRed,
              text: Text(
                "Cerrar sesión",
                style: subHeading2White,
              ),
              height: size.height * 0.06,
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    SvgPicture.asset("assets/logout.svg", color: Colors.white),
              ),
              action: () async {
                print("Cerrando sesión");
                if (await logout(context)) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const IntroScreen()),
                      (Route<dynamic> route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderSettings() => settingsList
      .map(
        (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SettingComponent(e["icon"], e["title"], e["route"]),
        ),
      )
      .toList();
}
