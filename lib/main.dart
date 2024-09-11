import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mining_solutions/demo/ui/splash.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/providers/new_direction_provider.dart';
import 'package:mining_solutions/providers/register_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/blog/hubmine_blog.dart';
import 'package:mining_solutions/screens/buy/checkout.dart';
import 'package:mining_solutions/screens/buy/details_checkout.dart';
import 'package:mining_solutions/screens/buy/resume_checkout.dart';
import 'package:mining_solutions/screens/cart/cart_page.dart';
import 'package:mining_solutions/screens/cart/select_date_shipping.dart';
import 'package:mining_solutions/screens/categorys/all_categorys_page.dart';
import 'package:mining_solutions/screens/concreto/concreto_step_four.dart';
import 'package:mining_solutions/screens/concreto/concreto_step_one.dart';
import 'package:mining_solutions/screens/concreto/concreto_step_three.dart';
import 'package:mining_solutions/screens/concreto/concreto_step_two.dart';
import 'package:mining_solutions/screens/concreto/select_date_shipping_concrete.dart';
import 'package:mining_solutions/screens/delete_account/delete_account.dart';
import 'package:mining_solutions/screens/driver/providers/register_like_hubber_provider.dart';
import 'package:mining_solutions/screens/driver/register/join_like_hubber_page.dart';
import 'package:mining_solutions/screens/intro/select_type_driver.dart';
import 'package:mining_solutions/screens/intro/what_describes_you.dart';
import 'package:mining_solutions/screens/locations/address_search_page.dart';
import 'package:mining_solutions/screens/login/login_page.dart';
import 'package:mining_solutions/screens/demos/textfields_demo_page.dart';
import 'package:mining_solutions/screens/login/login_with_biometrics.dart';
import 'package:mining_solutions/screens/notifications/notifications_page.dart';
import 'package:mining_solutions/screens/orders/orders_page.dart';
import 'package:mining_solutions/screens/referals/referals_page.dart';
import 'package:mining_solutions/screens/register/enter_code_register_with_phone.dart';
import 'package:mining_solutions/screens/register/register_with_phone.dart';
import 'package:mining_solutions/screens/rewards/rewards_page.dart';
import 'package:mining_solutions/screens/search/search_page.dart';
import 'package:mining_solutions/screens/settings/settings_page.dart';
import 'package:mining_solutions/screens/support/support_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';
import 'package:mining_solutions/widgets/check_ready.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/directions_provider.dart';
import 'providers/verification_code_info.dart';
import 'screens/intro/select_type_account.dart';
import 'screens/locations/current_location_page.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/demos/maps_demo.dart';
import 'screens/login/enter_verification_code_page.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_with_phone.dart';
import 'screens/maquinaria/maquinaria_page.dart';
import 'screens/recovery_password/recovery_password.dart';
import 'screens/profile/profile_page.dart';
import 'screens/register/registers_page.dart';
import 'screens/intro/splash_screen.dart';
import 'screens/register/step_two_register_page.dart';
import 'services/theme_services.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mining_solutions/generated/l10n.dart';

late SharedPreferences sharedPreferences;
void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await dotenv.load(fileName: "assets/config/.env");
  runApp(
    const MyApp(),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = primaryClr
    ..backgroundColor = primaryLightClr
    ..indicatorColor = primaryClr
    ..textColor = primaryClr
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withOpacity(0.21)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfo()),
        ChangeNotifierProvider(create: (_) => ConcretoInfo()),
        ChangeNotifierProvider(create: (_) => VerificationCodeInfo()),
        ChangeNotifierProvider(create: (_) => DirectionProvider()),
        ChangeNotifierProvider(create: (_) => RegisterInfo()),
        ChangeNotifierProvider(create: (_) => RegisterHubberInfo()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => NewDirectionProvider())
      ],
      child: GetMaterialApp(
          builder: (context, child) {
            child = EasyLoading.init()(context, child);
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          debugShowCheckedModeBanner: false,
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeService().theme,
          title: 'Hubmine',
          initialRoute: 'splash',
          routes: {
            "sp": (context) => const Splash(),
            "splash": (context) => const SplashPage(),
            "intro_screen": (context) => const IntroScreen(),
            "select_type_account": (context) => const SelectTypeAccountPage(),
            "what-describes-you-better": (context) =>
                const WhatDescribesYouScreen(),
            "login": (context) => const LoginPage(),
            "register-with-phone": (context) => const RegisterWithPhone(),
            "enter-verification-code-register-with-phone": (context) =>
                const EnterCodeRegisterWithPhone(),
            "register": (context) => const RegisterPage(),
            "step-two-register": (context) => const StepTwoRegisterPage(),
            "home": (context) => const HomePage(),
            "home-alpha": (context) => const HomePageAlpha(),
            "second": (context) => const SecondPage(),
            "login_with_phone": (context) => const LoginWithPhone(),
            "enter_verification_code": (context) =>
                const EnterVerificationCode(),
            "demo_maps": (context) => const DemoMaps(),
            // 'current_location_confirm': (context) =>
            //     const CurrentLocationPage(),
            "check-register": (context) => const CheckReady(),
            "profile": (context) => const ProfilePage(),
            "blog": (context) => const BlogPage(),
            "recovery-password": (context) => const RecoveryPassword(),
            "notifications": (context) => const NotificationsPage(),
            "rewards": (context) => const RewardsPage(),
            "referals": (context) => const ReferalsPage(),
            "settings": (context) => const SettingsPage(),
            "help": (context) => const SupportPage(),
            "delete_account": (context) => const DeleteAccount(),
            "all_categorys": (context) => const AllCategorysPage(),
            "search_page": (context) => const SearchPage(),
            "cart": (context) => const CartPage(),
            "address_search": (context) => const AddressSearchPage(),
            "checkout": (context) => const CheckoutPage(),
            // "resume-checkout": (context) => const ResumeCheckoutPage(),
            "details-checkout": (context) => const DetailsCheckoutPage(),
            "orders-page": (context) => const OrdersPage(),

            "select-date-shipping": (context) => const SelectDateShippingPage(),
            "select-date-shipping-concrete": (context) =>
                const SelectDateShippingConcretePage(),

            // Hubbers
            "join_like_hubber": (context) => const JoinLikeHubberPage(),
            "select-type-driver": (context) => const SelectTypeDriver(),
            
            // Concreto
            "concreto-step-one": (context) => const ConcretoStepOne(),
            "concreto-step-two": (context) => const ConcretoStepTwo(),
            "concreto-step-three": (context) => const ConcretoStepThree(),
            "concreto-step-four": (context) => const ConcretoStepFour(),

            "maquinaria": (context) => const MaquinariaPage(),

            "loginWithBiometrics": (context) => const LoginWithBiometricsPage()
          },
          localizationsDelegates: const [
            // ... delegado[s] de localización específicos de la app aquí
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.delegate.supportedLocales),
    );
  }
}
