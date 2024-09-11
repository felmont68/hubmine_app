import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Configuraciones", style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        child: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Cuenta', style: subHeading1),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                    leading:
                        SvgPicture.asset("assets/logout.svg", color: textBlack),
                    title: Text('Cerrar sesión', style: subHeading2),
                    onPressed: (BuildContext context) async {
                      print("Cerrando sesión");
                      if (await logout(context)) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const IntroScreen()),
                            (Route<dynamic> route) => false);
                      }
                    }),
                SettingsTile.navigation(
                  leading: Icon(Icons.delete, color: accentRed),
                  onPressed: (BuildContext context) {
                    Navigator.of(context).pushNamed("delete_account");
                  },
                  title:
                      Text('Solicitar eliminar cuenta', style: subHeading2Red),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
