import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/buy/create_order.dart';
import 'package:mining_solutions/screens/buy/data/payments.dart';
import 'package:mining_solutions/screens/buy/data/trucks.dart';
import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
import 'package:mining_solutions/services/cart_services.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/services/location_services.dart';
import 'package:mining_solutions/services/orders_services.dart';
import 'package:mining_solutions/widgets/input_model.dart';
import 'package:mining_solutions/widgets/stepper_button.dart';
import 'package:provider/provider.dart';

class DetailsCheckoutPage extends StatefulWidget {
  const DetailsCheckoutPage({Key? key}) : super(key: key);

  @override
  State<DetailsCheckoutPage> createState() => _DetailsCheckoutPageState();
}

class _DetailsCheckoutPageState extends State<DetailsCheckoutPage> {
  String shipping = "0";
  String kms = "0";

  calculatePriceShipping() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    var data =
        await calculateShipping(locationProvider.iDLocationSelected.toString());
    if (data.isNotEmpty) {
      var km = data['km'];
      var chargeToCustomer = data['charge_to_customer'];
      var totalShipping = chargeToCustomer;

      setState(() {
        shipping = totalShipping.toStringAsFixed(2);
        kms = km.toStringAsFixed(2);
      });
    } else {}
  }

  calculateTotal(cart) {
    var subtotal =
        cart.map((e) => e['subtotal'] as double).reduce((a, b) => a + b);
    var myshipping = double.parse(shipping) *
        cart.map((e) => e['quantity'] as double).reduce((a, b) => a + b);

    var iva = (subtotal + myshipping) * 0.16;

    var total = subtotal + myshipping + iva;

    return total;
  }

  calculateIVA(cart) {
    var products =
        cart.map((e) => e['subtotal'] as double).reduce((a, b) => a + b);

    var myshipping = double.parse(shipping) *
        cart.map((e) => e['quantity'] as double).reduce((a, b) => a + b);

    var subtotal = products + myshipping;

    var iva = subtotal * 0.16;
    return iva.toStringAsFixed(2);
  }

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _tipoDeCamion = TextEditingController();
  String? truckSeleted;

  final TextEditingController _methodPaymenth = TextEditingController();
  String? methodPaymenthSelected;

  final TextEditingController _whoReceivesController = TextEditingController();

  List<LocationData> _dataLocations = [];

  _fetchDataDirections() async {
    _dataLocations = await ServiceDirections.fetchDirectionsAll();
    //setState(() {});
  }

  loadFuture() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    var future =
        fetchLocationDetails(locationProvider.iDLocationSelected.toString());
    setState(() {});
    return future;
  }

  @override
  void initState() {
    super.initState();
    _fetchDataDirections();
    loadFuture();
    calculatePriceShipping();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    List cart = userInfo.cart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Detalles de compra", style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: cart.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                          color: gray05,
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(28),
                      child: const Icon(Iconsax.bag4, color: gray80, size: 32),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Center(
                          child: Text(
                            "Aún no tienes productos en tu carrito. No puedes hacer una compra",
                            style: bodyGray80,
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 5),
                  children: [
                      Card(
                          elevation: 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/dollar-circle.svg",
                                            color: primaryClr),
                                        const SizedBox(width: 4),
                                        Text("Método de pago",
                                            style: subHeading1),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        shape: const SmoothRectangleBorder(
                                          borderRadius:
                                              SmoothBorderRadius.vertical(
                                            top: SmoothRadius(
                                                cornerRadius: 20,
                                                cornerSmoothing: 1),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return CustomBottomSheet(
                                              title:
                                                  "¿Cómo deseas pagar tu pedido?",
                                              options: methodsPayments,
                                              onTap: (value) {
                                                _methodPaymenth.text = value;
                                                setState(() {
                                                  methodPaymenthSelected =
                                                      value;
                                                });
                                                Navigator.pop(context);
                                              });
                                        });
                                  },
                                  child: InputDropdown(
                                      isRequired: true,
                                      controller: _methodPaymenth,
                                      label: "¿Cómo deseas pagar tu pedido?",
                                      hintText: "Selecciona un método de pago"),
                                ),
                              ],
                            ),
                          )),
                      Card(
                          elevation: 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/truck.svg",
                                            color: primaryClr),
                                        const SizedBox(width: 4),
                                        Text("Recepción del pedido",
                                            style: subHeading1),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        shape: const SmoothRectangleBorder(
                                          borderRadius:
                                              SmoothBorderRadius.vertical(
                                            top: SmoothRadius(
                                                cornerRadius: 20,
                                                cornerSmoothing: 1),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return CustomBottomSheet(
                                              title:
                                                  "¿Qué tipo de camiones pueden entrar a tu obra?",
                                              options: trucks,
                                              onTap: (value) {
                                                _tipoDeCamion.text = value;
                                                setState(() {
                                                  truckSeleted = value;
                                                });
                                                Navigator.pop(context);
                                              });
                                        });
                                  },
                                  child: InputDropdown(
                                      isRequired: true,
                                      controller: _tipoDeCamion,
                                      label:
                                          "¿Qué tipo de camiones pueden entrar a tu obra?",
                                      hintText: "Selecciona un tipo de camión"),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Input(
                                  controller: _whoReceivesController,
                                  keyboardType: TextInputType.text,
                                  autofillHint: const [AutofillHints.name],
                                  label: "Nombre de quien recibe en obra",
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "El nombre de quien recibe es requerido";
                                  //   }
                                  // }
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          )),
                    ])),
      bottomNavigationBar: Container(
        height: 220,
        // margin: const EdgeInsets.only(bottom: 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Resumen de la compra", style: heading3),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal", style: subHeading1),
                    Text(
                        r"$" +
                            cart
                                .map((e) => e['subtotal'] as double)
                                .reduce((a, b) => a + b)
                                .toStringAsFixed(2),
                        style: subHeading1)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Envío ($kms km)", style: subHeading1),
                    Text(
                        r"$" +
                            ((double.parse(shipping)) *
                                    cart
                                        .map((e) => e['quantity'] as double)
                                        .reduce((a, b) => a + b))
                                .toStringAsFixed(2),
                        style: subHeading1)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Iva e impuestos", style: subHeading1),
                    Text(r"$" "${calculateIVA(cart)}", style: subHeading1)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () async {
                    print("Details checkout: " + cart[0].toString());

                    // Usando el ID de agregado, de haberlo
                    String finalId = (cart.first["price_cart"]
                                ["aggregates_list_id"] ??
                            cart.first['product']['product_id'])
                        .toString();

                    if (cart.isNotEmpty) {
                      var response = await createOrder(
                          locationProvider.iDLocationSelected.toString(),
                          _tipoDeCamion.text,
                          // cart[0]['product']['product_id'].toString(),
                          finalId,
                          cart
                              .map((e) => e['quantity'] as double)
                              .reduce((a, b) => a + b)
                              .toStringAsFixed(2),
                          cart[0]['price'].toString(),
                          (double.parse(shipping) *
                                  cart
                                      .map((e) => e['quantity'] as double)
                                      .reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                          cart
                              .map((e) => e['subtotal'] as double)
                              .reduce((a, b) => a + b)
                              .toString(),
                          calculateIVA(cart).toString(),
                          calculateTotal(cart).toString(),
                          context);

                      debugPrint("Order response: $response");
                      if (response.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => CreateOrder(
                                    order: response,
                                  )),
                        );
                      } else {
                        debugPrint(
                            "Cart en Provider: ${userInfo.cart.toString()}");
                        Get.snackbar(
                          "Error",
                          "Ocurrió un error al crear la orden",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: accentRed,
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: const EdgeInsets.all(20),
                          borderColor: accentRed,
                          borderWidth: 1,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ordenar ahora', style: btnLight),
                      Row(
                        children: [
                          Text('Total: ', style: carrouselSubHeading),
                          Text(
                            "\$ ${(cart.isEmpty ? 0.00 : calculateTotal(cart).toStringAsFixed(2))}",
                            style: carrouselHeading,
                          )
                        ],
                      ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: cart.isEmpty ? gray60 : primaryClr,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 1,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> renderCartItems(List cart) {
    return cart.asMap().entries.map((entry) {
      // Al iterar como mapa, podemos determinar en qué elementos les
      // corresponde el margen inferior
      int i = entry.key;
      Map item = entry.value;

      return Container(
        height: 108,
        decoration: BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(
              color: gray05,
              width: i != cart.length - 1 ? 1 : 0,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  // TODO: Cambiar por url de imagen. Determinar cuál es el endpoint
                  item['product']["product_url_image"],
                  height: 82,
                  width: 82,
                ),
              ),
            ),
            Wrap(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(item['product']["product_name"],
                          style: cartItemHeading),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                          "\$ ${(item["subtotal"] as double).toStringAsFixed(2)} MXN",
                          style: cartItemSubHeading),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      StepperButton("down", onTap: () {
                        if (item["quantity"] > 0.25) {
                          setState(() {
                            item["quantity"] -= 0.25;
                            item["subtotal"] = item["price"] * item["quantity"];
                          });
                        }
                      }),
                      Text("${(item["quantity"]).toStringAsFixed(2)} tons",
                          style: cartItemQuantity),
                      StepperButton(
                        "up",
                        onTap: () {
                          if (item["quantity"] < 5000) {
                            setState(() {
                              item["quantity"] += 0.25;
                              item["subtotal"] =
                                  item["price"] * item["quantity"];
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (cart.length > 1) {
                              deleteProductFromCart(
                                  item['pk'].toString(), context);
                              setState(() {
                                // cart = List.from(cart)..removeAt(i);
                                cart.removeAt(i);
                              });
                            } else {
                              deleteProductFromCart(
                                  item['pk'].toString(), context);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Icon(Iconsax.trash, color: accentRed),
                          )),
                    ],
                  )),
            )
          ],
        ),
      );
    }).toList();
  }
}

class AddressShipingWidget extends StatefulWidget {
  final String name;
  final String direction;
  final String city;
  final String state;
  const AddressShipingWidget({
    Key? key,
    required this.name,
    required this.direction,
    required this.city,
    required this.state,
  }) : super(key: key);

  @override
  State<AddressShipingWidget> createState() => _AddressShipingWidgetState();
}

class _AddressShipingWidgetState extends State<AddressShipingWidget> {
  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    return Container();
  }
}
