import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import '../../theme.dart';

import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController deleteController = TextEditingController();
  bool isSameWord = false;
  String word = "eliminar";

  _checkValue() {
    if (deleteController.text == word) {
      setState(() {
        isSameWord = true;
      });
    } else {
      setState(() {
        isSameWord = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    deleteController.addListener(_checkValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text("Eliminar cuenta", style: subHeading1)),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 45.0, right: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hola ${userInfo.firstName}", style: subHeadingTextStyle),
                RichText(
                  text: TextSpan(
                      text:
                          "Lamentamos oir que te quieres ir, si esto es algo temporal puedes simplemente ",
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          text: "cerrar sesión",
                          style: bodyTextPrimaryStyle,
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () =>
                                // TODO: Mandar a llamar servicio de cerrar sesión
                                print(
                                    'Abriendo página de términos y condiciones'),
                        ),
                      ]),
                ),
                SizedBox(height: 20),
                Text(
                    "Si deseas continuar con la eliminación de tu cuenta escribe la palabra indicada en el recuadro de texto ",
                    style: bodyTextStyle),
                SizedBox(height: 20),
                Input(
                  hintText: word,
                  label: word,
                  controller: deleteController,
                ),
                SizedBox(height: 5),
                isSameWord
                    ? Container(
                        height: 110,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            gradient: LinearGradient(
                                colors: [Colors.white, Colors.white],
                                stops: [0.5, 0.8],
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Button(
                                  color: const Color(0xFF259793),
                                  text: Text(
                                    "Eliminar cuenta",
                                    style: subHeading2White,
                                  ),
                                  width: double.infinity,
                                  height: size.height * 0.06,
                                  action: () async {
                                    print("Eliminando cuenta");
                                    if (await deleteAccount()) {
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
                        ),
                      )
                    : Container(
                        height: 110,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            gradient: LinearGradient(
                                colors: [Colors.white, Colors.white],
                                stops: [0.5, 0.8],
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ButtonDisabled(
                                  text: Text(
                                    "Eliminar cuenta",
                                    style: subHeading2White,
                                  ),
                                  width: double.infinity,
                                  height: size.height * 0.06,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
