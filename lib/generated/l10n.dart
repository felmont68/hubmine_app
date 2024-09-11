// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `¿De donde eres?`
  String get selectCountry {
    return Intl.message(
      '¿De donde eres?',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Bienvenido a Hubmine`
  String get loginStartSession {
    return Intl.message(
      'Bienvenido a Hubmine',
      name: 'loginStartSession',
      desc: '',
      args: [],
    );
  }

  /// `El ecosistema digital de la construcción`
  String get loginStartSessionSubtitle {
    return Intl.message(
      'El ecosistema digital de la construcción',
      name: 'loginStartSessionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get loginEmailLabel {
    return Intl.message(
      'Correo electrónico',
      name: 'loginEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa tu correo electrónico`
  String get loginEmailHintText {
    return Intl.message(
      'Ingresa tu correo electrónico',
      name: 'loginEmailHintText',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get loginPasswordLabel {
    return Intl.message(
      'Contraseña',
      name: 'loginPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa tu contraseña`
  String get loginPasswordHintText {
    return Intl.message(
      'Ingresa tu contraseña',
      name: 'loginPasswordHintText',
      desc: '',
      args: [],
    );
  }

  /// `o`
  String get loginOrOption {
    return Intl.message(
      'o',
      name: 'loginOrOption',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa con Número de Teléfono`
  String get loginWithPhoneLabel {
    return Intl.message(
      'Ingresa con Número de Teléfono',
      name: 'loginWithPhoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa con Correo Electrónico`
  String get loginWithEmailLabel {
    return Intl.message(
      'Ingresa con Correo Electrónico',
      name: 'loginWithEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `¿Olvidaste tu contraseña?`
  String get loginForgotPasswordLink {
    return Intl.message(
      '¿Olvidaste tu contraseña?',
      name: 'loginForgotPasswordLink',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get loginButton {
    return Intl.message(
      'Iniciar sesión',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `¿No tienes una cuenta? `
  String get loginBottomNavHaventAccount {
    return Intl.message(
      '¿No tienes una cuenta? ',
      name: 'loginBottomNavHaventAccount',
      desc: '',
      args: [],
    );
  }

  /// `Regístrate`
  String get loginBottomNavHaventAccountLink {
    return Intl.message(
      'Regístrate',
      name: 'loginBottomNavHaventAccountLink',
      desc: '',
      args: [],
    );
  }

  /// `Entrar como invitado`
  String get loginAsGuest {
    return Intl.message(
      'Entrar como invitado',
      name: 'loginAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Enviar código`
  String get loginSendCode {
    return Intl.message(
      'Enviar código',
      name: 'loginSendCode',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña`
  String get recoveryPasswordTitle {
    return Intl.message(
      'Recuperar contraseña',
      name: 'recoveryPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recupera el acceso a tu cuenta restableciendo tu contraseña`
  String get recoveryPasswordSubtitle {
    return Intl.message(
      'Recupera el acceso a tu cuenta restableciendo tu contraseña',
      name: 'recoveryPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enviar código de recuperación`
  String get recoveryPasswordButton {
    return Intl.message(
      'Enviar código de recuperación',
      name: 'recoveryPasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa un email válido`
  String get validatorEmailError {
    return Intl.message(
      'Ingresa un email válido',
      name: 'validatorEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Este campo es requerido`
  String get validatorRequiredField {
    return Intl.message(
      'Este campo es requerido',
      name: 'validatorRequiredField',
      desc: '',
      args: [],
    );
  }

  /// `Número de teléfono inválido`
  String get validatorPhoneNumberInvalid {
    return Intl.message(
      'Número de teléfono inválido',
      name: 'validatorPhoneNumberInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Obtén un código de inicio de sesión`
  String get getCodeTitle {
    return Intl.message(
      'Obtén un código de inicio de sesión',
      name: 'getCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Te enviaremos un SMS al número asociado a tu cuenta`
  String get getCodeSubtitle {
    return Intl.message(
      'Te enviaremos un SMS al número asociado a tu cuenta',
      name: 'getCodeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Número de teléfono *`
  String get phoneNumberLabelRequired {
    return Intl.message(
      'Número de teléfono *',
      name: 'phoneNumberLabelRequired',
      desc: '',
      args: [],
    );
  }

  /// `Número de teléfono`
  String get phoneNumberHint {
    return Intl.message(
      'Número de teléfono',
      name: 'phoneNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa el código de verificación`
  String get enterVerificationCodeTitle {
    return Intl.message(
      'Ingresa el código de verificación',
      name: 'enterVerificationCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `¿No recibiste el código?`
  String get didntGetACode {
    return Intl.message(
      '¿No recibiste el código?',
      name: 'didntGetACode',
      desc: '',
      args: [],
    );
  }

  /// `Enviar nuevo código de verificación`
  String get resendVerificationCode {
    return Intl.message(
      'Enviar nuevo código de verificación',
      name: 'resendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verificar`
  String get verifyCodeLabel {
    return Intl.message(
      'Verificar',
      name: 'verifyCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Solicitar un código para el registro`
  String get registerWithPhoneTitle {
    return Intl.message(
      'Solicitar un código para el registro',
      name: 'registerWithPhoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Te enviaremos un SMS al número que registres`
  String get registerWithPhoneSubtitle {
    return Intl.message(
      'Te enviaremos un SMS al número que registres',
      name: 'registerWithPhoneSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Buscar país`
  String get registerWithPhoneSearchCountry {
    return Intl.message(
      'Buscar país',
      name: 'registerWithPhoneSearchCountry',
      desc: '',
      args: [],
    );
  }

  /// `Enviamos un código a `
  String get weSendACodeText {
    return Intl.message(
      'Enviamos un código a ',
      name: 'weSendACodeText',
      desc: '',
      args: [],
    );
  }

  /// `Nuevo código enviado ✅`
  String get newCodeSentText {
    return Intl.message(
      'Nuevo código enviado ✅',
      name: 'newCodeSentText',
      desc: '',
      args: [],
    );
  }

  /// `¿Qué te describe mejor?`
  String get registerProfileTitle {
    return Intl.message(
      '¿Qué te describe mejor?',
      name: 'registerProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Siguiente`
  String get nextButtonText {
    return Intl.message(
      'Siguiente',
      name: 'nextButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Finalizar registro`
  String get finishedButtonText {
    return Intl.message(
      'Finalizar registro',
      name: 'finishedButtonText',
      desc: '',
      args: [],
    );
  }

  //biometria
  String get loginWithBiometriaLabel {
    return Intl.message(
      'Ingresar con biometría',
      name: 'loginWithBiometriaLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es', countryCode: 'MX'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
