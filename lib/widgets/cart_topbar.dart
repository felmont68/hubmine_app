import "package:flutter/material.dart";
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

// TODO: Añadir flecha de retroceso opcional, ícono variable

class CartTopbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CartTopbar({required this.title, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: subHeading1),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Iconsax.arrow_left, color: Colors.black),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("cart");
            },
            icon: const Icon(Iconsax.bag5, color: textBlack))
      ],
    );
  }
}
