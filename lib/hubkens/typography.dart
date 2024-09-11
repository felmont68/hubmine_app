import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mining_solutions/hubkens/colors.dart';

TextStyle get titleTextStyle {
  return GoogleFonts.inter(
      fontSize: 26.0,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get h2TextStyle {
  return GoogleFonts.inter(
      fontSize: 21.0,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get h3TextDarkStyle {
  return GoogleFonts.inter(
      fontSize: 16, color: primaryClr, fontWeight: FontWeight.w600);
}

TextStyle get h3TextStyle {
  return GoogleFonts.inter(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
}

TextStyle get bodyTextStyle {
  return GoogleFonts.inter(
      color: Get.isDarkMode ? Colors.white : Colors.black, fontSize: 15);
}

TextStyle get bodyTextBoldStyle {
  return GoogleFonts.inter(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.w600);
}

TextStyle get bodyTextGreyBoldStyle {
  return GoogleFonts.inter(
      color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500);
}

TextStyle get bodyTextBoldIntroStyle {
  return GoogleFonts.inter(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16);
}

TextStyle get bodyTextPrimaryStyle {
  return GoogleFonts.inter(
      color: primaryClr, fontWeight: FontWeight.w600, fontSize: 15);
}

TextStyle get bodyTermsStyle {
  return GoogleFonts.inter(fontSize: 14.0, color: Colors.grey);
}

TextStyle get bodyTermsPrimaryStyle {
  return GoogleFonts.inter(
      decoration: TextDecoration.underline,
      letterSpacing: -0.6,
      fontSize: 14,
      color: primaryClr,
      fontWeight: FontWeight.w600);
}

TextStyle get buttonTextStyle {
  return GoogleFonts.inter(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
}

TextStyle get buttonConfirmTextStyle {
  return GoogleFonts.inter(
      fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle get buttonTextDarkStyle {
  return GoogleFonts.inter(
      fontSize: 16, color: primaryClr, fontWeight: FontWeight.w600);
}

TextStyle get loginTextStyle {
  return GoogleFonts.inter(
      fontSize: 24, color: primaryClr, fontWeight: FontWeight.w700);
}

TextStyle get subtitleLoginTextStyle {
  return GoogleFonts.inter(fontSize: 14, color: darkGreyClr);
}

TextStyle get subtitleLoginTextDoneStyle {
  return GoogleFonts.inter(
      letterSpacing: -0.5,
      fontSize: 14,
      color: Colors.green,
      fontWeight: FontWeight.w600);
}

TextStyle get passwordLoginTextStyle {
  return GoogleFonts.inter(fontSize: 14, color: primaryClr);
}

// Home
TextStyle get subHeadingTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: const Color(0xFF6C6969));
}

TextStyle get subHeadingTextBlackStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black);
}

TextStyle get subHeadingDarkTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 18, color: primaryClr);
}

TextStyle get subHeadingPrimaryTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 21, color: primaryClr);
}

TextStyle get subHeadingDirectionTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black);
}

TextStyle get subDirectionTextStyle {
  return GoogleFonts.inter(fontSize: 17, color: const Color(0xFF6C6969));
}

TextStyle get titlesHomeTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get inputLabelTextStyle {
  return GoogleFonts.inter(fontSize: 15.0, color: Colors.grey);
}

TextStyle get introTitleTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 23.0, color: Colors.white);
}

TextStyle get introParTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.white);
}

TextStyle get titleLogoTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 40.0, color: Colors.white);
}

TextStyle get titleLogoDarkTextStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 40.0, color: primaryLightClr);
}

TextStyle get loadingStyle {
  return GoogleFonts.inter(fontSize: 15.0, color: Colors.white);
}

TextStyle get categoryBlog {
  return GoogleFonts.inter(
      fontSize: 14, color: primaryClr, fontWeight: FontWeight.w600);
}

TextStyle get btnLight {
  return GoogleFonts.inter(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle get datePostedBlog {
  return GoogleFonts.inter(
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);
}

TextStyle get subtitleProducts {
  return GoogleFonts.inter(
      fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700);
}

TextStyle get descriptionProduct {
  return GoogleFonts.inter(
    color: Colors.black.withOpacity(0.6),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

TextStyle get swipeBtnPrimary {
  return GoogleFonts.inter(
      fontSize: 16, color: primaryClr, fontWeight: FontWeight.w600);
}

TextStyle get swipeBtnSecondary {
  return GoogleFonts.inter(
      fontSize: 16, color: primaryLightClr, fontWeight: FontWeight.w600);
}

TextStyle get swipeBtnWhite {
  return GoogleFonts.inter(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle get swipeBtnGrey {
  return GoogleFonts.inter(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle get titleBottomModal {
  return GoogleFonts.inter(fontSize: 22, color: Colors.black45);
}

// Rebranding TextStyle

TextStyle get heading {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: textBlack,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get headingWhite {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get heading2Black {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: textBlack,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get heading2White {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get heading3 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: textBlack,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get heading3White {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get body {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: bodyGray,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyWhite {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.white,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyLink {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: primaryClr,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyGray40 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: gray40,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyGray60 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: gray60,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyGray80 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: gray80,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyBlack {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: textBlack,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get bodyLight {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: gray60,
    letterSpacing: -0.5,
    height: 1.3,
  );
}

TextStyle get subHeading1 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: textBlack,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading1Gray {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: gray40,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading1White {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: white,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading1Primary {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: primaryClr,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading2 {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: textBlack,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading2Gray {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: gray40,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading2Red {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: accentRed,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading2White {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.white,
    letterSpacing: -0.5,
  );
}

TextStyle get subHeading2PrimaryClr {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: primaryClr,
    letterSpacing: -0.6,
    height: 1.3,
  );
}

TextStyle get carrouselHeading {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Colors.white,
    letterSpacing: -0.5,
  );
}

TextStyle get carrouselSubHeading {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.white,
    letterSpacing: -0.5,
  );
}

TextStyle get categoriesLabel {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: textBlack,
    letterSpacing: -1,
  );
}

TextStyle get selectedLabelStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 14, color: primaryClr);
}

TextStyle get unSelectedLabelStyle {
  return GoogleFonts.inter(fontSize: 14, color: gray40);
}

TextStyle get smallBody {
  return GoogleFonts.inter(
    fontSize: 12,
    color: gray80,
    letterSpacing: -0.5,
  );
}

TextStyle get smallBodyWhite {
  return GoogleFonts.inter(
    fontSize: 12,
    color: Colors.white,
    letterSpacing: -0.5,
  );
}

TextStyle get smallBodyRed {
  return GoogleFonts.inter(
    fontSize: 12,
    color: accentRed,
    letterSpacing: -0.5,
  );
}

TextStyle get hintTextStyle {
  return GoogleFonts.inter(
    fontSize: 14,
    color: gray40,
    letterSpacing: -0.5,
  );
}

TextStyle get captions {
  return GoogleFonts.inter(
    fontSize: 12,
    color: gray60,
    letterSpacing: -0.5,
  );
}

TextStyle get captionPrimary {
  return GoogleFonts.inter(
      fontSize: 12,
      color: primaryClr,
      letterSpacing: -0.5,
      fontWeight: FontWeight.w600);
}

TextStyle get priceProductDetailsPage {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: -0.5,
      color: primaryClr);
}

TextStyle get subtitle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      letterSpacing: -0.5,
      color: textBlack);
}

TextStyle get disccountStyle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      letterSpacing: -0.6,
      color: Colors.white);
}

TextStyle get cartItemHeading {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: textBlack,
    letterSpacing: -0.5,
  );
}

TextStyle get cartItemSubHeading {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: primaryClr,
      letterSpacing: -0.5);
}

TextStyle get cartItemQuantity {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: textBlack,
    letterSpacing: -0.5,
  );
}

TextStyle get cartBadge {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: Colors.white,
    letterSpacing: -1,
  );
}

TextStyle get guestProfileCardTitle {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: white,
    letterSpacing: -0.5,
  );
}

TextStyle get guestProfileCardTitlePrimary {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: primaryClr,
    letterSpacing: -0.5,
  );
}

TextStyle get onboardingTitle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 28,
      letterSpacing: -0.5,
      color: white);
}

TextStyle get onboardingSubtitle {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: -0.5,
      color: gray20);
}

TextStyle get cardTitle {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: -0.5,
  );
}

TextStyle get dropdownHeader {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: gray100,
    letterSpacing: -0.5,
  );
}
