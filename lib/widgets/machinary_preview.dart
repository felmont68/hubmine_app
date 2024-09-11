import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/products/details_machinary.dart';
import 'package:mining_solutions/screens/products/details_product.dart';

class MachinaryPreview extends StatelessWidget {
  final String? productID;
  final String? supplierName;
  final String? productName;
  final String? category;
  final String? image;
  final String? shortDescription;
  final String? description;
  final String? initialPrice;
  final String? measures;
  final String? volumetricWeight;
  final String? disccount;
  const MachinaryPreview(
      {Key? key,
      required this.productID,
      this.supplierName,
      this.productName,
      this.category,
      this.image,
      this.shortDescription,
      this.description,
      this.initialPrice,
      this.measures,
      this.volumetricWeight,
      this.disccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => DetailsMachinaryPage(
              productID: productID as String,
              supplierName: supplierName as String,
              descrption: description as String,
              imageAsset: image as String,
              titleProduct: productName as String,
              category: category as String,
              price: initialPrice as String,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
          child: Row(children: [
            Stack(children: [
              CachedNetworkImage(
                imageUrl: "$image",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              disccount! != "0"
                  ? Positioned(
                      left: 9,
                      top: 12,
                      child: Container(
                          height: 24,
                          width: 54,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                color: Colors.red,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              "${disccount.toString()}% off",
                              style: disccountStyle,
                              textAlign: TextAlign.center,
                            ),
                          )),
                    )
                  : Container(),
            ]),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$supplierName", style: subtitle),
                    Text("$productName", style: heading3),
                    const SizedBox(height: 8),
                    Text("$shortDescription", style: body),
                    const SizedBox(height: 8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$initialPrice", style: subHeading2PrimaryClr),
                          SvgPicture.asset("assets/arrow_right.svg",
                              width: 24, height: 24, color: primaryClr),
                        ])
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
