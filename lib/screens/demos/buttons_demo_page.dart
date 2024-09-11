import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';

import 'package:mining_solutions/widgets/button_model.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo de botones"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Button(
                  color: Colors.green,
                ),
                SizedBox(height: 30.0),
                Button(
                  color: accentRed,
                ),
                SizedBox(height: 30.0),
                Button(
                  color: Colors.indigo,
                )
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "second");
        },
      ),
    );
  }
}
