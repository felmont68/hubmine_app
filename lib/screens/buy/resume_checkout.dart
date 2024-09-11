// import 'package:figma_squircle/figma_squircle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:mining_solutions/hubkens/colors.dart';
// import 'package:mining_solutions/hubkens/typography.dart';
// import 'package:mining_solutions/models/location_data.dart';
// import 'package:mining_solutions/providers/location_provider.dart';
// import 'package:mining_solutions/providers/user_info_provider.dart';
// import 'package:mining_solutions/screens/buy/create_order.dart';
// import 'package:mining_solutions/screens/buy/data/payments.dart';
// import 'package:mining_solutions/screens/buy/data/trucks.dart';
// import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
// import 'package:mining_solutions/screens/home/home_page.dart';
// import 'package:mining_solutions/screens/locations/current_location_page.dart';
// import 'package:mining_solutions/screens/locations/edit_location_page.dart';
// import 'package:mining_solutions/services/cart_services.dart';
// import 'package:mining_solutions/services/directions_services.dart';
// import 'package:mining_solutions/services/location_services.dart';
// import 'package:mining_solutions/services/orders_services.dart';
// import 'package:mining_solutions/services/storage_services.dart';
// import 'package:mining_solutions/widgets/input_model.dart';
// import 'package:mining_solutions/widgets/stepper_button.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';

// class ResumeCheckoutPage extends StatefulWidget {
//   const ResumeCheckoutPage({Key? key}) : super(key: key);

//   @override
//   State<ResumeCheckoutPage> createState() => _ResumeCheckoutPageState();
// }

// class _ResumeCheckoutPageState extends State<ResumeCheckoutPage> {
//   String shipping = "0";
//   String kms = "0";

//   calculatePriceShipping() async {
//     final locationProvider =
//         Provider.of<LocationProvider>(context, listen: false);
//     var data =
//         await calculateShipping(locationProvider.iDLocationSelected.toString());
//     if (data.isNotEmpty) {
//       var km = data['km'];
//       var chargeToCustomer = data['charge_to_customer'];
//       var totalShipping = chargeToCustomer;

//       setState(() {
//         shipping = totalShipping.toStringAsFixed(2);
//         kms = km.toStringAsFixed(2);
//       });
//     } else {}
//   }

//   calculateTotal(cart) {
//     var subtotal =
//         cart.map((e) => e['subtotal'] as double).reduce((a, b) => a + b);
//     var myshipping = double.parse(shipping) *
//         cart.map((e) => e['quantity'] as double).reduce((a, b) => a + b);

//     var iva = (subtotal + myshipping) * 0.16;

//     var total = subtotal + myshipping + iva;

//     return total;
//   }

//   calculateIVA(cart) {
//     var products =
//         cart.map((e) => e['subtotal'] as double).reduce((a, b) => a + b);

//     var myshipping = double.parse(shipping) *
//         cart.map((e) => e['quantity'] as double).reduce((a, b) => a + b);

//     var subtotal = products + myshipping;

//     var iva = subtotal * 0.16;
//     return iva.toStringAsFixed(2);
//   }

//   final TextEditingController _tipoDeCamion = TextEditingController();
//   String? truckSeleted;

//   final TextEditingController _methodPaymenth = TextEditingController();
//   String? methodPaymenthSelected;

//   final TextEditingController _whoReceivesController = TextEditingController();

//   List<LocationData> _dataLocations = [];

//   _fetchDataDirections() async {
//     _dataLocations = await ServiceDirections.fetchDirectionsAll();
//     //setState(() {});
//   }

//   loadFuture() async {
//     final locationProvider =
//         Provider.of<LocationProvider>(context, listen: false);
//     var future =
//         fetchLocationDetails(locationProvider.iDLocationSelected.toString());
//     setState(() {});
//     return future;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchDataDirections();
//     loadFuture();
//     calculatePriceShipping();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userInfo = Provider.of<UserInfo>(context, listen: false);
//     final locationProvider =
//         Provider.of<LocationProvider>(context, listen: false);
//     List cart = userInfo.cart;

//     _setIcon(int typeLocation, int iDLocationSelected) {
//       switch (typeLocation) {
//         case 1:
//           return SvgPicture.asset("assets/house.svg",
//               width: 25, height: 25, color: gray80);

//         case 2:
//           return SvgPicture.asset("assets/buliding.svg",
//               width: 25, height: 25, color: gray80);
//         case 3:
//           return SvgPicture.asset("assets/plant.svg",
//               width: 25, height: 25, color: gray80);
//         case 4:
//           return SvgPicture.asset("assets/corporate.svg",
//               width: 25, height: 25, color: gray80);
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text("Detalles de compra", style: subHeading1),
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Iconsax.arrow_left, color: Colors.black),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//           child: cart.isEmpty
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 64,
//                       width: 64,
//                       decoration: BoxDecoration(
//                           color: gray05,
//                           borderRadius: BorderRadius.circular(24)),
//                       padding: const EdgeInsets.all(16),
//                       margin: const EdgeInsets.all(28),
//                       child: const Icon(Iconsax.bag4, color: gray80, size: 32),
//                     ),
//                     SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.5,
//                         child: Center(
//                           child: Text(
//                             "Aún no tienes productos en tu carrito. No puedes hacer una compra",
//                             style: bodyGray80,
//                             textAlign: TextAlign.center,
//                           ),
//                         )),
//                   ],
//                 )
//               : ListView(
//                   padding: const EdgeInsets.only(
//                       left: 20.0, right: 20, bottom: 20, top: 5),
//                   children: [
//                       Card(
//                           elevation: 0.4,
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 8.0, right: 8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset("assets/cart.svg",
//                                         color: primaryClr),
//                                     const SizedBox(width: 4),
//                                     Text("Tus productos", style: subHeading1),
//                                   ],
//                                 ),
//                                 const Divider(),
//                                 ...renderCartItems(cart),
//                               ],
//                             ),
//                           )),
//                       FutureBuilder(
//                           future: loadFuture(),
//                           builder:
//                               (BuildContext context, AsyncSnapshot snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SkeletonItem(
//                                     child: SkeletonLine(
//                                       style: SkeletonLineStyle(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, right: 20.0),
//                                           height: 120,
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           borderRadius:
//                                               BorderRadius.circular(16)),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                 ],
//                               );
//                             } else if (snapshot.data!.isNotEmpty) {
//                               Map location = snapshot.data;

//                               return Card(
//                                   elevation: 0.3,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 const Icon(Iconsax.location5,
//                                                     color: primaryClr),
//                                                 const SizedBox(width: 4),
//                                                 Text("Dirección de entrega",
//                                                     style: subHeading1),
//                                               ],
//                                             ),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   showModalBottomSheet(
//                                                     context: context,
//                                                     isScrollControlled: true,
//                                                     shape:
//                                                         SmoothRectangleBorder(
//                                                       borderRadius:
//                                                           SmoothBorderRadius(
//                                                         cornerRadius: 30,
//                                                         cornerSmoothing: 1,
//                                                       ),
//                                                     ),
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       return StatefulBuilder(
//                                                           builder: (BuildContext
//                                                                   context,
//                                                               StateSetter
//                                                                   myState) {
//                                                         return SizedBox(
//                                                           height: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .height -
//                                                               250,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 20,
//                                                                     left: 10.0,
//                                                                     right:
//                                                                         10.0),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Center(
//                                                                   child: Wrap(
//                                                                       children: [
//                                                                         SizedBox(
//                                                                             width:
//                                                                                 20,
//                                                                             height:
//                                                                                 6,
//                                                                             child:
//                                                                                 Container(
//                                                                               // color: HMColor.primary,
//                                                                               decoration: const BoxDecoration(color: primaryClr, borderRadius: BorderRadius.all(Radius.circular(4))),
//                                                                             )),
//                                                                       ]),
//                                                                 ),
//                                                                 Container(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       left: 20,
//                                                                       top: 20,
//                                                                       bottom:
//                                                                           10,
//                                                                       right:
//                                                                           10),
//                                                                   child: Text(
//                                                                     'Agrega o escoge una dirección de entrega',
//                                                                     style:
//                                                                         heading,
//                                                                   ),
//                                                                 ),
//                                                                 Container(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       top: 10,
//                                                                       left: 10,
//                                                                       right: 10,
//                                                                       bottom:
//                                                                           10),
//                                                                   child:
//                                                                       const SearchAddressInput(
//                                                                     hintText:
//                                                                         "Ingresa una dirección",
//                                                                     suffixIcon: Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             top:
//                                                                                 5,
//                                                                             bottom:
//                                                                                 5.0,
//                                                                             right:
//                                                                                 20),
//                                                                         child: Icon(
//                                                                             Iconsax
//                                                                                 .location5,
//                                                                             color:
//                                                                                 gray20)),
//                                                                   ),
//                                                                 ),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       left: 0.0,
//                                                                       right:
//                                                                           10.0),
//                                                                   child:
//                                                                       InkWell(
//                                                                     onTap: () {
//                                                                       Navigator.of(
//                                                                               context)
//                                                                           .push(
//                                                                         MaterialPageRoute(builder:
//                                                                             (BuildContext
//                                                                                 context) {
//                                                                           return const CurrentLocationPage();
//                                                                         }),
//                                                                       );
//                                                                     },
//                                                                     child:
//                                                                         ListTile(
//                                                                       leading:
//                                                                           const Padding(
//                                                                         padding:
//                                                                             EdgeInsets.only(left: 5.0),
//                                                                         child: Icon(
//                                                                             Iconsax.gps5),
//                                                                       ),
//                                                                       title:
//                                                                           Text(
//                                                                         'Ubicación Actual',
//                                                                         style:
//                                                                             subHeading1,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Expanded(
//                                                                   child: ListView
//                                                                       .builder(
//                                                                     itemCount:
//                                                                         _dataLocations
//                                                                             .length,
//                                                                     itemBuilder:
//                                                                         (BuildContext
//                                                                                 context,
//                                                                             int index) {
//                                                                       return InkWell(
//                                                                         onTap:
//                                                                             () {
//                                                                           locationProvider
//                                                                               .setiDLocationSelected(_dataLocations[index].id);

//                                                                           calculatePriceShipping();
//                                                                           loadFuture();

//                                                                           myState(
//                                                                               () {});
//                                                                         },
//                                                                         child:
//                                                                             ListTile(
//                                                                           leading: Padding(
//                                                                               padding: const EdgeInsets.only(left: 4),
//                                                                               child: locationProvider.iDLocationSelected == _dataLocations[index].id ? const Icon(Icons.check, color: primaryClr) : _setIcon(_dataLocations[index].tagId, locationProvider.iDLocationSelected)),
//                                                                           trailing:
//                                                                               DropdownButton(
//                                                                             icon:
//                                                                                 const Icon(Iconsax.more),
//                                                                             elevation:
//                                                                                 16,
//                                                                             style:
//                                                                                 subHeading1,
//                                                                             onChanged:
//                                                                                 (int? newValue) async {
//                                                                               if (newValue == 0) {
//                                                                                 if (await ServiceDirections.deleteDirection(_dataLocations[index].id)) {
//                                                                                   var userType = await ServiceStorage.getUserTypeId();
//                                                                                   if (userType == 1) {
//                                                                                     print("Se disparó el primer if");
//                                                                                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (Route<dynamic> route) => false);
//                                                                                   }
//                                                                                 }
//                                                                               } else {
//                                                                                 Navigator.of(context).push(
//                                                                                   MaterialPageRoute(
//                                                                                       builder: (BuildContext context) => EditLocationPage(
//                                                                                             data: LocationData(
//                                                                                               id: _dataLocations[index].id,
//                                                                                               city: _dataLocations[index].city,
//                                                                                               details: _dataLocations[index].details,
//                                                                                               directionInOneLine: _dataLocations[index].directionInOneLine,
//                                                                                               name: _dataLocations[index].name,
//                                                                                               state: _dataLocations[index].state,
//                                                                                               tagId: _dataLocations[index].tagId,
//                                                                                               lat: _dataLocations[index].lat,
//                                                                                               log: _dataLocations[index].log,
//                                                                                               haveDetails: _dataLocations[index].haveDetails,
//                                                                                             ),
//                                                                                           )),
//                                                                                 );
//                                                                               }
//                                                                             },
//                                                                             items: [
//                                                                               DropdownMenuItem<int>(
//                                                                                 value: 0,
//                                                                                 child: Text('Eliminar', style: body),
//                                                                               ),
//                                                                               DropdownMenuItem<int>(
//                                                                                 value: 1,
//                                                                                 child: Text('Editar', style: body),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           title:
//                                                                               Text(
//                                                                             _dataLocations[index].directionInOneLine,
//                                                                             style:
//                                                                                 subHeading1,
//                                                                           ),
//                                                                         ),
//                                                                       );
//                                                                     },
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       });
//                                                     },
//                                                   );
//                                                   // Navigator.of(context).pushNamed('demo_maps');
//                                                   // print("Obteniendo ubicación");
//                                                 },
//                                                 child: Text("Cambiar",
//                                                     style: bodyLink))
//                                           ],
//                                         ),
//                                         const Divider(),
//                                         Text(
//                                           "${location['location_name']}, ${location['direction_line_1']}, ${location['city']} ${location['state']}, MX",
//                                           style: body,
//                                         ),
//                                         const SizedBox(height: 12),
//                                       ],
//                                     ),
//                                   ));
//                               //  AddressShipingWidget(
//                               //     name: location['location_name'],
//                               //     direction: location['direction_line_1'],
//                               //     city: location['city'],
//                               //     state: location['state']);
//                             } else {
//                               return Card(
//                                   elevation: 0.3,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 const Icon(Iconsax.location5,
//                                                     color: primaryClr),
//                                                 const SizedBox(width: 4),
//                                                 Text("Dirección de entrega",
//                                                     style: subHeading1),
//                                               ],
//                                             ),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   showModalBottomSheet(
//                                                     context: context,
//                                                     isScrollControlled: true,
//                                                     shape:
//                                                         SmoothRectangleBorder(
//                                                       borderRadius:
//                                                           SmoothBorderRadius(
//                                                         cornerRadius: 30,
//                                                         cornerSmoothing: 1,
//                                                       ),
//                                                     ),
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       return StatefulBuilder(
//                                                           builder: (BuildContext
//                                                                   context,
//                                                               StateSetter
//                                                                   myState) {
//                                                         return SizedBox(
//                                                           height: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .height -
//                                                               250,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 20,
//                                                                     left: 10.0,
//                                                                     right:
//                                                                         10.0),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Center(
//                                                                   child: Wrap(
//                                                                       children: [
//                                                                         SizedBox(
//                                                                             width:
//                                                                                 20,
//                                                                             height:
//                                                                                 6,
//                                                                             child:
//                                                                                 Container(
//                                                                               // color: HMColor.primary,
//                                                                               decoration: const BoxDecoration(color: primaryClr, borderRadius: BorderRadius.all(Radius.circular(4))),
//                                                                             )),
//                                                                       ]),
//                                                                 ),
//                                                                 Container(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       left: 20,
//                                                                       top: 20,
//                                                                       bottom:
//                                                                           10,
//                                                                       right:
//                                                                           10),
//                                                                   child: Text(
//                                                                     'Agrega o escoge una dirección de entrega',
//                                                                     style:
//                                                                         heading,
//                                                                   ),
//                                                                 ),
//                                                                 Container(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       top: 10,
//                                                                       left: 10,
//                                                                       right: 10,
//                                                                       bottom:
//                                                                           10),
//                                                                   child:
//                                                                       const SearchAddressInput(
//                                                                     hintText:
//                                                                         "Ingresa una dirección",
//                                                                     suffixIcon: Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             top:
//                                                                                 5,
//                                                                             bottom:
//                                                                                 5.0,
//                                                                             right:
//                                                                                 20),
//                                                                         child: Icon(
//                                                                             Iconsax
//                                                                                 .location5,
//                                                                             color:
//                                                                                 gray20)),
//                                                                   ),
//                                                                 ),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       left: 0.0,
//                                                                       right:
//                                                                           10.0),
//                                                                   child:
//                                                                       InkWell(
//                                                                     onTap: () {
//                                                                       Navigator.of(
//                                                                               context)
//                                                                           .push(
//                                                                         MaterialPageRoute(builder:
//                                                                             (BuildContext
//                                                                                 context) {
//                                                                           return const CurrentLocationPage();
//                                                                         }),
//                                                                       );
//                                                                     },
//                                                                     child:
//                                                                         ListTile(
//                                                                       leading:
//                                                                           const Padding(
//                                                                         padding:
//                                                                             EdgeInsets.only(left: 5.0),
//                                                                         child: Icon(
//                                                                             Iconsax.gps5),
//                                                                       ),
//                                                                       title:
//                                                                           Text(
//                                                                         'Ubicación Actual',
//                                                                         style:
//                                                                             subHeading1,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Expanded(
//                                                                   child: ListView
//                                                                       .builder(
//                                                                     itemCount:
//                                                                         _dataLocations
//                                                                             .length,
//                                                                     itemBuilder:
//                                                                         (BuildContext
//                                                                                 context,
//                                                                             int index) {
//                                                                       return InkWell(
//                                                                         onTap:
//                                                                             () {
//                                                                           locationProvider
//                                                                               .setiDLocationSelected(_dataLocations[index].id);

//                                                                           calculatePriceShipping();
//                                                                           loadFuture();

//                                                                           myState(
//                                                                               () {});
//                                                                         },
//                                                                         child:
//                                                                             ListTile(
//                                                                           leading: Padding(
//                                                                               padding: const EdgeInsets.only(left: 4),
//                                                                               child: locationProvider.iDLocationSelected == _dataLocations[index].id ? const Icon(Icons.check, color: primaryClr) : _setIcon(_dataLocations[index].tagId, locationProvider.iDLocationSelected)),
//                                                                           trailing:
//                                                                               DropdownButton(
//                                                                             icon:
//                                                                                 const Icon(Iconsax.more),
//                                                                             elevation:
//                                                                                 16,
//                                                                             style:
//                                                                                 subHeading1,
//                                                                             onChanged:
//                                                                                 (int? newValue) async {
//                                                                               if (newValue == 0) {
//                                                                                 if (await ServiceDirections.deleteDirection(_dataLocations[index].id)) {
//                                                                                   var userType = await ServiceStorage.getUserTypeId();
//                                                                                   if (userType == 1) {
//                                                                                     print("Se disparó el primer if");
//                                                                                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (Route<dynamic> route) => false);
//                                                                                   }
//                                                                                 }
//                                                                               } else {
//                                                                                 Navigator.of(context).push(
//                                                                                   MaterialPageRoute(
//                                                                                       builder: (BuildContext context) => EditLocationPage(
//                                                                                             data: LocationData(
//                                                                                               id: _dataLocations[index].id,
//                                                                                               city: _dataLocations[index].city,
//                                                                                               details: _dataLocations[index].details,
//                                                                                               directionInOneLine: _dataLocations[index].directionInOneLine,
//                                                                                               name: _dataLocations[index].name,
//                                                                                               state: _dataLocations[index].state,
//                                                                                               tagId: _dataLocations[index].tagId,
//                                                                                               lat: _dataLocations[index].lat,
//                                                                                               log: _dataLocations[index].log,
//                                                                                               haveDetails: _dataLocations[index].haveDetails,
//                                                                                             ),
//                                                                                           )),
//                                                                                 );
//                                                                               }
//                                                                             },
//                                                                             items: [
//                                                                               DropdownMenuItem<int>(
//                                                                                 value: 0,
//                                                                                 child: Text('Eliminar', style: body),
//                                                                               ),
//                                                                               DropdownMenuItem<int>(
//                                                                                 value: 1,
//                                                                                 child: Text('Editar', style: body),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           title:
//                                                                               Text(
//                                                                             _dataLocations[index].directionInOneLine,
//                                                                             style:
//                                                                                 subHeading1,
//                                                                           ),
//                                                                         ),
//                                                                       );
//                                                                     },
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       });
//                                                     },
//                                                   );
//                                                   // Navigator.of(context).pushNamed('demo_maps');
//                                                   // print("Obteniendo ubicación");
//                                                 },
//                                                 child: Text("Seleccionar",
//                                                     style: bodyLink))
//                                           ],
//                                         ),
//                                         const Divider(),
//                                         Text(
//                                           "Seleccione una ubicación",
//                                           style: body,
//                                         ),
//                                         const SizedBox(height: 12),
//                                       ],
//                                     ),
//                                   ));
//                             }
//                           }),
//                       Card(
//                           elevation: 0.3,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                             "assets/dollar-circle.svg",
//                                             color: primaryClr),
//                                         const SizedBox(width: 4),
//                                         Text("Método de pago",
//                                             style: subHeading1),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(),
//                                 const SizedBox(height: 8),
//                                 InkWell(
//                                   onTap: () {
//                                     showModalBottomSheet<void>(
//                                         isScrollControlled: true,
//                                         context: context,
//                                         shape: SmoothRectangleBorder(
//                                           borderRadius: SmoothBorderRadius(
//                                             cornerRadius: 32,
//                                             cornerSmoothing: 1,
//                                           ),
//                                         ),
//                                         builder: (BuildContext context) {
//                                           return CustomBottomSheet(
//                                               title:
//                                                   "¿Cómo deseas pagar tu pedido?",
//                                               options: methodsPayments,
//                                               onTap: (value) {
//                                                 _methodPaymenth.text = value;
//                                                 setState(() {
//                                                   methodPaymenthSelected =
//                                                       value;
//                                                 });
//                                                 Navigator.pop(context);
//                                               });
//                                         });
//                                   },
//                                   child: InputDropdown(
//                                       isRequired: true,
//                                       controller: _methodPaymenth,
//                                       label: "¿Cómo deseas pagar tu pedido?",
//                                       hintText: "Selecciona un método de pago"),
//                                 ),
//                               ],
//                             ),
//                           )),
//                       Card(
//                           elevation: 0.3,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset("assets/truck.svg",
//                                             color: primaryClr),
//                                         const SizedBox(width: 4),
//                                         Text("Detalles para el envío",
//                                             style: subHeading1),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(),
//                                 InkWell(
//                                   onTap: () {
//                                     showModalBottomSheet<void>(
//                                         isScrollControlled: true,
//                                         context: context,
//                                         shape: SmoothRectangleBorder(
//                                           borderRadius: SmoothBorderRadius(
//                                             cornerRadius: 32,
//                                             cornerSmoothing: 1,
//                                           ),
//                                         ),
//                                         builder: (BuildContext context) {
//                                           return CustomBottomSheet(
//                                               title:
//                                                   "¿Qué tipo de camiones pueden entrar a tu obra?",
//                                               options: trucks,
//                                               onTap: (value) {
//                                                 _tipoDeCamion.text = value;
//                                                 setState(() {
//                                                   truckSeleted = value;
//                                                 });
//                                                 Navigator.pop(context);
//                                               });
//                                         });
//                                   },
//                                   child: InputDropdown(
//                                       isRequired: true,
//                                       controller: _tipoDeCamion,
//                                       label:
//                                           "¿Qué tipo de camiones pueden entrar a tu obra?",
//                                       hintText: "Selecciona un tipo de camión"),
//                                 ),
//                                 const SizedBox(
//                                   height: 16,
//                                 ),
//                                 Input(
//                                   controller: _whoReceivesController,
//                                   keyboardType: TextInputType.text,
//                                   autofillHint: const [AutofillHints.name],
//                                   label: "Nombre de quien recibe en obra",
//                                   // validator: (value) {
//                                   //   if (value!.isEmpty) {
//                                   //     return "El nombre de quien recibe es requerido";
//                                   //   }
//                                   // }
//                                 ),
//                                 const SizedBox(height: 8),
//                               ],
//                             ),
//                           )),
//                     ])),
//       bottomNavigationBar: Container(
//         height: 180,
//         // margin: const EdgeInsets.only(bottom: 0),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(25)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Subtotal", style: subHeading1),
//                     Text(
//                         r"$" +
//                             cart
//                                 .map((e) => e['subtotal'] as double)
//                                 .reduce((a, b) => a + b)
//                                 .toStringAsFixed(2),
//                         style: subHeading1)
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Envío ($kms km)", style: subHeading1),
//                     Text(
//                         r"$" +
//                             ((double.parse(shipping)) *
//                                     cart
//                                         .map((e) => e['quantity'] as double)
//                                         .reduce((a, b) => a + b))
//                                 .toStringAsFixed(2),
//                         style: subHeading1)
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Iva e impuestos", style: subHeading1),
//                     Text(r"$" "${calculateIVA(cart)}", style: subHeading1)
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton(
//                   // TODO: Lógica de pago
//                   onPressed: () async {
//                     print(cart[0]);
//                     if (cart.isNotEmpty) {
//                       var response = await createOrder(
//                           locationProvider.iDLocationSelected.toString(),
//                           _tipoDeCamion.text,
//                           cart[0]['product']['product_id'].toString(),
//                           cart
//                               .map((e) => e['quantity'] as double)
//                               .reduce((a, b) => a + b)
//                               .toStringAsFixed(2),
//                           cart[0]['price'].toString(),
//                           (double.parse(shipping) *
//                                   cart
//                                       .map((e) => e['quantity'] as double)
//                                       .reduce((a, b) => a + b))
//                               .toStringAsFixed(2),
//                           cart
//                               .map((e) => e['subtotal'] as double)
//                               .reduce((a, b) => a + b)
//                               .toString(),
//                           calculateIVA(cart).toString(),
//                           calculateTotal(cart).toString(),
//                           context);
//                       if (response.isNotEmpty) {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => CreateOrder(
//                                     order: response,
//                                   )),
//                         );
//                       } else {
//                         print("Ocurrió un error al crear la orden");
//                       }
//                     }
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Ordenar ahora', style: btnLight),
//                       Row(
//                         children: [
//                           Text('Total: ', style: carrouselSubHeading),
//                           Text(
//                             "\$ ${(cart.isEmpty ? 0.00 : calculateTotal(cart).toStringAsFixed(2))}",
//                             style: carrouselHeading,
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   style: TextButton.styleFrom(
//                     elevation: 0,
//                     backgroundColor: cart.isEmpty ? gray60 : primaryClr,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 16),
//                     shape: SmoothRectangleBorder(
//                       borderRadius: SmoothBorderRadius(
//                         cornerRadius: 16,
//                         cornerSmoothing: 1,
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> renderCartItems(List cart) {
//     return cart.asMap().entries.map((entry) {
//       // Al iterar como mapa, podemos determinar en qué elementos les
//       // corresponde el margen inferior
//       int i = entry.key;
//       Map item = entry.value;

//       return Container(
//         height: 108,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: BorderDirectional(
//             bottom: BorderSide(
//               color: gray05,
//               width: i != cart.length - 1 ? 1 : 0,
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(
//                   // TODO: Cambiar por url de imagen. Determinar cuál es el endpoint
//                   item['product']["product_url_image"],
//                   height: 82,
//                   width: 82,
//                 ),
//               ),
//             ),
//             Wrap(
//               direction: Axis.vertical,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Text(item['product']["product_name"],
//                           style: cartItemHeading),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Text(
//                           "\$ ${(item["subtotal"] as double).toStringAsFixed(2)} MXN",
//                           style: cartItemSubHeading),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   child: Row(
//                     children: [
//                       StepperButton("down", onTap: () {
//                         if (item["quantity"] > 0.25) {
//                           setState(() {
//                             item["quantity"] -= 0.25;
//                             item["subtotal"] = item["price"] * item["quantity"];
//                           });
//                         }
//                       }),
//                       Text("${(item["quantity"]).toStringAsFixed(2)} tons",
//                           style: cartItemQuantity),
//                       StepperButton(
//                         "up",
//                         onTap: () {
//                           if (item["quantity"] < 5000) {
//                             setState(() {
//                               item["quantity"] += 0.25;
//                               item["subtotal"] =
//                                   item["price"] * item["quantity"];
//                             });
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Wrap(
//                     alignment: WrapAlignment.center,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             if (cart.length > 1) {
//                               deleteProductFromCart(
//                                   item['pk'].toString(), context);
//                               setState(() {
//                                 // cart = List.from(cart)..removeAt(i);
//                                 cart.removeAt(i);
//                               });
//                             } else {
//                               deleteProductFromCart(
//                                   item['pk'].toString(), context);
//                               Navigator.of(context).pop();
//                             }
//                           },
//                           child: const Padding(
//                             padding: EdgeInsets.only(bottom: 12.0),
//                             child: Icon(Iconsax.trash, color: accentRed),
//                           )),
//                     ],
//                   )),
//             )
//           ],
//         ),
//       );
//     }).toList();
//   }
// }

// class AddressShipingWidget extends StatefulWidget {
//   final String name;
//   final String direction;
//   final String city;
//   final String state;
//   const AddressShipingWidget({
//     Key? key,
//     required this.name,
//     required this.direction,
//     required this.city,
//     required this.state,
//   }) : super(key: key);

//   @override
//   State<AddressShipingWidget> createState() => _AddressShipingWidgetState();
// }

// class _AddressShipingWidgetState extends State<AddressShipingWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final locationProvider =
//         Provider.of<LocationProvider>(context, listen: false);
//     return Container();
//   }
// }
