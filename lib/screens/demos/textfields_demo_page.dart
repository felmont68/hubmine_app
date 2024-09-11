import 'package:flutter/material.dart';
import 'package:mining_solutions/widgets/input_model.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo de cuadros de texto"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Input(
                icon: Icon(Icons.person),
                label: "Nombre",
              ),
              const SizedBox(
                height: 40,
              ),
              const Input(
                label: "Apellido",
              ),
              const SizedBox(
                height: 40,
              ),
              const Input(
                label: "Contraseña",
                icon: Icon(Icons.remove_red_eye_sharp),
              ),
              const SizedBox(
                height: 40,
              ),
              const Input(
                label: "Confirmar contraseña",
                icon: Icon(Icons.lock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
