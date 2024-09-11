import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/cart_services.dart';
import 'package:mining_solutions/widgets/show_custom_bottom_sheet.dart';
import 'package:mining_solutions/widgets/stepper_button.dart';

import '../../hubkens/colors.dart';
import '../../providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _cartValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isValid = false;
  // List<Map> cart = List.filled(10, {
  //   "id": 2,
  //   "user_id": 129,
  //   "product_id": 1,
  //   "product__category__category_name": "Agregados",
  //   "product__unity_unity__name": "Tonelada",
  //   "product__product_name": "Piedra caliza",
  //   "product__description": "Piedra para construcción ",
  //   "product__image": "products/piedra.jpg", // TODO: ¿De qué endpoint es esta ruta relativa?
  //   "product__price": 100.0,
  //   "quantity": 3,
  //   "subtotal": 300.0,
  //   "is_buyed": false
  // });
  List cart = [];

  loadCart() async {
    var futureCart = await fetchMyCart();
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    userInfo.cart = futureCart;
    print(futureCart);
    setState(() {
      cart = userInfo.cart;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Mi carrito", style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                        color: gray05, borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(28),
                    child: const Icon(Iconsax.bag4, color: gray80, size: 32),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Center(
                        child: Text(
                          "Aún no tienes productos en tu carrito",
                          style: bodyGray80,
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(
                    cart[index],
                    index,
                    index == cart.length - 1,
                    setState,
                    // _cartValue,
                    _formKey,
                    // _buildConfig,
                    // _nodeText,
                    () => setState(() {
                          cart.removeAt(index);
                        }));
              },
              itemCount: cart.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              physics: const NeverScrollableScrollPhysics(),
            ),
      bottomNavigationBar: Container(
        height: 100,
        // margin: const EdgeInsets.only(bottom: 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: CartBottomBar(cart: cart),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Map item;
  final int index;
  final bool last;
  final void Function(void Function() fn) setParentState;
  final GlobalKey<FormState> _formKey;
  // final KeyboardActionsConfig Function(BuildContext) _buildConfig;
  // final FocusNode _nodeText;
  final VoidCallback removeItem;

  CartItem(
      this.item,
      this.index,
      this.last,
      this.setParentState,
      // this._cartValue,
      this._formKey,
      // this._buildConfig,
      // this._nodeText,
      this.removeItem,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode _nodeText = FocusNode();
    KeyboardActionsConfig _buildConfig(BuildContext context) {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(focusNode: _nodeText, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  node.unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text("Listo", style: subHeading1Primary),
                ),
              );
            }
          ]),
        ],
      );
    }

    Map product = item['product'];
    Map unitMap = product["product_unity"];
    String unit = unitMap["unity_name"];
    String unitDescription =
        unitMap["unity_description"].toString().toLowerCase();
    String unitPlural = (unitMap["unity_description_plural"] ?? "unidades")
        .toString()
        .toLowerCase();

    Map techFeatures = product["product_tech_feat"];
    num min = techFeatures["minimum_value"];
    num max = techFeatures["maximum_value"];
    num step = techFeatures["increase"];

    bool isInteger = step % 1 == 0;

    if (isInteger) {
      min = min.toInt();
      max = max.toInt();
      step = step.toInt();
    }

    // final TextEditingController _cartValue = TextEditingController.fromValue(
    //     TextEditingValue(
    //         text: item['quantity'].toString(),
    //         selection: TextSelection.collapsed(
    //             offset: item['quantity'].toString().length)));

    String currentValue = (item['quantity'] as num).toString();

    final TextEditingController _cartValue =
        TextEditingControllerWithCursorPosition(text: currentValue);

    return Container(
      // height: 108,
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderDirectional(
          bottom: BorderSide(
            color: gray05,
            // width: i != cart.length - 1 ? 1 : 0,
            width: last ? 0 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
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
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(item['product']["product_name"],
                      style: cartItemHeading),
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
                        if (item["quantity"] > min) {
                          setParentState(() {
                            item["quantity"] -= step;

                            item["subtotal"] = item["price"] * item["quantity"];
                          });
                        }
                      }),
                      InkWell(
                        onTap: () {
                          print("Abriendo bottomsheet");
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.vertical(
                                  top: SmoothRadius(
                                      cornerRadius: 20, cornerSmoothing: 1),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setParentState) {
                                  return SingleChildScrollView(
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Decoración al principio del bottom sheet
                                            Center(
                                              child: Wrap(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: SizedBox(
                                                      width: 20,
                                                      height: 6,
                                                      child: Container(
                                                        // color: HMColor.primary,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color:
                                                                    primaryClr,
                                                                borderRadius:
                                                                    // ignore: unnecessary_const
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            4))),
                                                      )),
                                                ),
                                              ]),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 10.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "¿Cuántas ${unitPlural} necesitas?",
                                                      style: heading),
                                                  Text(
                                                      "Puedes comprar desde $min ${unitPlural} en adelante, incrementando de $step en $step",
                                                      style: body)
                                                ],
                                              ),
                                            ),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 6),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        StepperButton("down",
                                                            onTap: () {
                                                          if (item["quantity"] >
                                                              min) {
                                                            setParentState(() {
                                                              item["quantity"] -=
                                                                  step;

                                                              item["subtotal"] =
                                                                  item["price"] *
                                                                      item[
                                                                          "quantity"];
                                                            });
                                                          }
                                                          // setParentState(() {});
                                                        }),
                                                        SizedBox(
                                                          width: 250,
                                                          height: 100,
                                                          child:
                                                              KeyboardActions(
                                                            config:
                                                                _buildConfig(
                                                                    context),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const SizedBox(
                                                                    height: 4),
                                                                Form(
                                                                  key: _formKey,
                                                                  onChanged:
                                                                      () {
                                                                    final isValid =
                                                                        _formKey
                                                                            .currentState!
                                                                            .validate();
                                                                    if (isValid) {
                                                                      print(
                                                                          "Ok todo bien");
                                                                      setParentState(
                                                                          () {
                                                                        try {
                                                                          item["quantity"] = isInteger
                                                                              ? int.parse(_cartValue.text)
                                                                              : double.parse(_cartValue.text);
                                                                          item["subtotal"] =
                                                                              item["price"] * item["quantity"];
                                                                        } catch (e) {
                                                                          debugPrint(
                                                                              e.toString());
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: TextFormField(
                                                                      validator: (value) {
                                                                        try {
                                                                          if (value!
                                                                              .isNotEmpty) {
                                                                            if (isInteger
                                                                                ? int.parse(value) % step == 0
                                                                                : double.parse(value) % step == 0) {
                                                                              return null;
                                                                            } else {
                                                                              return "Solo puede aumentar de $step en $step";
                                                                            }
                                                                          } else {
                                                                            return "Ingrese un dato válido (+$min)";
                                                                          }
                                                                        } catch (e) {
                                                                          debugPrint(
                                                                              e.toString());
                                                                        }
                                                                      },
                                                                      focusNode: _nodeText,
                                                                      keyboardType: const TextInputType.numberWithOptions(
                                                                        decimal:
                                                                            true,
                                                                      ),
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        LengthLimitingTextInputFormatter(isInteger
                                                                            ? 4
                                                                            : 7),
                                                                        // FilteringTextInputFormatter(
                                                                        //     RegExp(
                                                                        //         r'^\d+\.?\d{0,2}'),
                                                                        //     allow:
                                                                        //         true),
                                                                        if (isInteger)
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        else
                                                                          DecimalTextInputFormatter(
                                                                              decimalRange: 2),
                                                                      ],
                                                                      textInputAction: TextInputAction.go,
                                                                      onFieldSubmitted: (value) {
                                                                        print(
                                                                            "Go button is clicked");
                                                                      },
                                                                      textAlign: TextAlign.center,
                                                                      minLines: 1, //Normal textInputField will be displayed
                                                                      controller: _cartValue,
                                                                      style: subHeading1,
                                                                      onChanged: (value) {
                                                                        debugPrint(
                                                                            "new value: $value");
                                                                        // try {
                                                                        //   setParentState(
                                                                        //       () {
                                                                        //     item["quantity"] = isInteger
                                                                        //         ? int.parse(value)
                                                                        //         : double.parse(value);
                                                                        //     item["subtotal"] =
                                                                        //         item["price"] * item["quantity"];
                                                                        //   });
                                                                        // } catch (e) {
                                                                        //   debugPrint(
                                                                        //       e.toString());
                                                                        // }
                                                                      },
                                                                      decoration: InputDecoration(

                                                                          // hintText: widget.hintText,
                                                                          hintStyle: bodyGray40,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16.0),
                                                                            borderSide:
                                                                                const BorderSide(color: gray20),
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16.0),
                                                                            borderSide:
                                                                                const BorderSide(color: primaryClr),
                                                                          ),
                                                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: accentRed)),
                                                                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: accentRed)))),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        StepperButton(
                                                          "up",
                                                          onTap: () {
                                                            if (item[
                                                                    "quantity"] <
                                                                max) {
                                                              setParentState(
                                                                  () {
                                                                item["quantity"] +=
                                                                    step;
                                                                item["subtotal"] =
                                                                    item["price"] *
                                                                        item[
                                                                            "quantity"];
                                                              });
                                                            }
                                                            setParentState(
                                                                () {});
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(height: 8),
                                          ],
                                        )),
                                  );
                                });
                              }).whenComplete(() => {
                                // Actualizar el subtotal
                                setParentState(() {
                                  item["subtotal"] =
                                      item["price"] * item["quantity"];
                                })
                              });
                        },
                        child: Text(
                            "${isInteger ? (item["quantity"] as num).toInt().toString() : (item["quantity"] as double).toStringAsFixed(2)} $unit",
                            style: cartItemQuantity),
                      ),
                      StepperButton(
                        "up",
                        onTap: () {
                          if (item["quantity"] < max) {
                            setParentState(() {
                              item["quantity"] += step;
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
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          deleteProductFromCart(item['pk'].toString(), context);
                          removeItem();
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
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final List cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                if (cart.isNotEmpty) {
                  // iterate cart and parse all numeric values to double
                  for (var item in cart) {
                    item["price"] = double.parse(item["price"].toString());
                    item["quantity"] =
                        double.parse(item["quantity"].toString());
                    item["subtotal"] =
                        double.parse(item["subtotal"].toString());
                  }

                  Navigator.of(context).pushNamed("checkout");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ordenar ahora', style: btnLight),
                  Row(
                    children: [
                      Text('Subtotal: ', style: carrouselSubHeading),
                      Text(
                        "\$ ${(cart.isEmpty ? 0.00 : cart.map((e) => e['subtotal'] as double).reduce((a, b) => a + b)).toStringAsFixed(2)}",
                        style: carrouselHeading,
                      )
                    ],
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: cart.isEmpty ? gray60 : primaryClr,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 16,
                    cornerSmoothing: 1,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// Soluciona el bug del cursor yendo al medio del input
class TextEditingControllerWithCursorPosition extends TextEditingController {
  TextEditingControllerWithCursorPosition({required String text})
      : super(text: text);

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: value.selection,
      composing: TextRange.empty,
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
