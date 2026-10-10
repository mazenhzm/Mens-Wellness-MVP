import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[Locale('en'), Locale('ar')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final value = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(
      value != null,
      'AppLocalizations are not available in this context.',
    );
    return value!;
  }

  bool get _isArabic => locale.languageCode == 'ar';

  String get appName => _isArabic ? 'عافية' : 'Wellbeing';
  String get welcomeTitle => _isArabic
      ? 'مساحة خاصة لرفاهيتك.'
      : 'A private space for your wellbeing.';
  String get welcomeBody => _isArabic
      ? 'معلومات صحية موثوقة، بخطوات تراعي خصوصيتك.'
      : 'Thoughtful health guidance, with your privacy in mind.';
  String get continueToAccount =>
      _isArabic ? 'متابعة إلى الحساب' : 'Continue to account';
  String get authTitle =>
      _isArabic ? 'حسابك، بأمان.' : 'Your account, secured.';
  String get authBody => _isArabic
      ? 'سجّل الدخول أو أنشئ حساباً للمتابعة.'
      : 'Sign in or create an account to continue.';
  String get privacyNote => _isArabic
      ? 'لا نعرض معلومات صحية حساسة على هذه الشاشة.'
      : 'Sensitive health information is not shown on this screen.';
  String get accountTitle => _isArabic ? 'أهلاً بك' : 'You’re signed in';
  String get accountBody => _isArabic
      ? 'لم تتم إضافة بيانات صحية إلى حسابك بعد.'
      : 'No health information has been added to your account yet.';
  String get serviceStatus => _isArabic ? 'اتصال الخدمة' : 'Service connection';
  String get sessionStatus => _isArabic ? 'جلسة الحساب' : 'Account session';
  String get checkConnection =>
      _isArabic ? 'التحقق من الاتصال' : 'Check connection';
  String get connectionReady =>
      _isArabic ? 'الخدمة متاحة' : 'Service is available';
  String get connectionUnavailable =>
      _isArabic ? 'تعذر الاتصال بالخدمة' : 'Service could not be reached';
  String get sessionVerified =>
      _isArabic ? 'تم التحقق من الجلسة' : 'Session verified';
  String get sessionUnavailable =>
      _isArabic ? 'تعذر التحقق من الجلسة' : 'Session could not be verified';
  String get connectionNotChecked =>
      _isArabic ? 'لم يتم التحقق بعد' : 'Not checked yet';
  String get signOut => _isArabic ? 'تسجيل الخروج' : 'Sign out';
  String get configurationTitle =>
      _isArabic ? 'إعداد التطبيق غير مكتمل' : 'App setup is incomplete';
  String get configurationBody => _isArabic
      ? 'يرجى تشغيل التطبيق بإعدادات البيئة المطلوبة.'
      : 'Run the app with the required environment configuration.';

  TextDirection get textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const {'en', 'ar'}.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
