import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String company;
  final String rfc;

  const EditProfilePage(
      {Key? key,
      required this.name,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.company,
      required this.rfc})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController rfcController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isSomethingChanged = false;
  final _formKey = GlobalKey<FormState>();

  _insertData() async {
    nameController = TextEditingController(text: widget.name);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    companyController = TextEditingController(text: widget.company);
    phoneController = TextEditingController(text: widget.phone);
    rfcController = TextEditingController(text: widget.rfc);
    setState(() {});
  }

  @override
  void initState() {
    _insertData();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future getImage(userInfo) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      Permission.photos.request();
    }
    final image = await _picker.pickImage(source: ImageSource.gallery);
    _image = File(image!.path);
    var response = await uploadPhoto(_image, userInfo);
    if (response["isOk"]) {
      setState(() {
        userInfo.profilePhotoPath = response['photo'];
      });
    } else {
      EasyLoading.showError("Ups! Ocurrió un error...",
          duration: const Duration(milliseconds: 3000));
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Editar perfil", style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      bottomNavigationBar: isSomethingChanged
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
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Button(
                        color: primaryClr,
                        text: Text(
                          "Guardar cambios",
                          style: subHeading2White,
                        ),
                        width: double.infinity,
                        height: size.height * 0.06,
                        action: () async {
                          if (_formKey.currentState!.validate()) {
                            // TODO: Call the API to UPDATE Profile
                            print("Guardando cambios");
                            if (await updateProfile(
                                nameController.text,
                                lastNameController.text,
                                phoneController.text,
                                emailController.text,
                                companyController.text,
                                rfcController.text,
                                context)) {
                              setState(() {});
                            }
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
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonDisabled(
                        text: Text(
                          "Guardar cambios",
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
      body: Container(
        color: Colors.white,
        height: height,
        width: width,
        child: ListView(children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.1))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: userInfo.profilePhotoPath == "" ||
                                userInfo.profilePhotoPath == null
                            ? const NetworkImage(
                                "https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/user-by-default.png")
                            : NetworkImage(
                                'http://23.100.25.47:8010/media/' +
                                    userInfo.profilePhotoPath,
                              ),
                      )),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implementar el servicio de Seleccionar y Actualizar la foto
                        print("Tiempo de editar la foto");
                        getImage(userInfo);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: primaryClr,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                          child: const Icon(Icons.edit, color: Colors.white)),
                    ))
              ],
            ),
          ),
          Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                isSomethingChanged = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Input(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    autofillHint: const [AutofillHints.givenName],
                    label: "Nombre",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Tu nombre es requerido";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Input(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      autofillHint: const [AutofillHints.familyName],
                      label: "Apellido",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Tu apellido es requerido";
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  Input(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      autofillHint: const [
                        AutofillHints.telephoneNumberNational
                      ],
                      label:
                          AppLocalizations.of(context).phoneNumberLabelRequired,
                      validator: (value) {
                        if (value!.length < 12) {
                          return "Ingrese un número de teléfono valido con código de país";
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  Input(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: "Email",
                      validator: (value) =>
                          !isEmail(value!) ? "Ingrese un email valido" : null),
                  const SizedBox(height: 20),
                  Input(
                    controller: companyController,
                    keyboardType: TextInputType.text,
                    label: "Compañía",
                  ),
                  const SizedBox(height: 20),
                  Input(
                    controller: rfcController,
                    keyboardType: TextInputType.text,
                    label: "RFC (Opcional)",
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
