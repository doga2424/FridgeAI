import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'myProfile': 'My Profile',
      'editProfile': 'Edit Profile',
      'notifications': 'Notifications',
      'privacySecurity': 'Privacy & Security',
      'name': 'Name',
      'email': 'Email',
      'enterYourName': 'Enter your name',
      'enterYourEmail': 'Enter your email',
      'save': 'Save',
      'cancel': 'Cancel',
      'settings': 'Settings',
      'language': 'Language',
      'profileSettings': 'Profile Settings',
      'profileUpdated': 'Profile updated successfully',
      'errorUpdating': 'Error updating profile',
      'close': 'Close',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm Password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordChanged': 'Password changed successfully',
      'errorChangingPassword': 'Error changing password',
      'appSettings': 'App Settings',
      'accountSettings': 'Account Settings',
      'helpSupport': 'Help & Support',
      'darkMode': 'Dark Mode',
      'faq': 'FAQ',
      'contactSupport': 'Contact Support',
      'logout': 'Logout',
      'logoutConfirmation': 'Logout Confirmation',
      'logoutMessage': 'Are you sure you want to logout?',
    },
    'tr': {
      'myProfile': 'Profilim',
      'editProfile': 'Profili Düzenle',
      'notifications': 'Bildirimler',
      'privacySecurity': 'Gizlilik ve Güvenlik',
      'name': 'İsim',
      'email': 'E-posta',
      'enterYourName': 'İsminizi girin',
      'enterYourEmail': 'E-posta adresinizi girin',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'settings': 'Ayarlar',
      'language': 'Dil',
      'profileSettings': 'Profil Ayarları',
      'profileUpdated': 'Profil başarıyla güncellendi',
      'errorUpdating': 'Profil güncellenirken hata oluştu',
      'close': 'Kapat',
      'changePassword': 'Şifre Değiştir',
      'currentPassword': 'Mevcut Şifre',
      'newPassword': 'Yeni Şifre',
      'confirmPassword': 'Şifreyi Onayla',
      'passwordsDoNotMatch': 'Şifreler eşleşmiyor',
      'passwordChanged': 'Şifre başarıyla değiştirildi',
      'errorChangingPassword': 'Şifre değiştirme hatası',
      'appSettings': 'Uygulama Ayarları',
      'accountSettings': 'Hesap Ayarları',
      'helpSupport': 'Yardım & Destek',
      'darkMode': 'Karanlık Mod',
      'faq': 'SSS',
      'contactSupport': 'Destek ile İletişim',
      'logout': 'Çıkış Yap',
      'logoutConfirmation': 'Çıkış Onayı',
      'logoutMessage': 'Çıkış yapmak istediğinizden emin misiniz?',
    },
  };

  String get myProfile => _localizedValues[locale.languageCode]!['myProfile']!;
  String get editProfile => _localizedValues[locale.languageCode]!['editProfile']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get privacySecurity => _localizedValues[locale.languageCode]!['privacySecurity']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get enterYourName => _localizedValues[locale.languageCode]!['enterYourName']!;
  String get enterYourEmail => _localizedValues[locale.languageCode]!['enterYourEmail']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get profileSettings => _localizedValues[locale.languageCode]!['profileSettings']!;
  String get profileUpdated => _localizedValues[locale.languageCode]!['profileUpdated']!;
  String get errorUpdating => _localizedValues[locale.languageCode]!['errorUpdating']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get changePassword => _localizedValues[locale.languageCode]!['changePassword']!;
  String get currentPassword => _localizedValues[locale.languageCode]!['currentPassword']!;
  String get newPassword => _localizedValues[locale.languageCode]!['newPassword']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirmPassword']!;
  String get passwordsDoNotMatch => _localizedValues[locale.languageCode]!['passwordsDoNotMatch']!;
  String get passwordChanged => _localizedValues[locale.languageCode]!['passwordChanged']!;
  String get errorChangingPassword => _localizedValues[locale.languageCode]!['errorChangingPassword']!;
  String get appSettings => _localizedValues[locale.languageCode]!['appSettings']!;
  String get accountSettings => _localizedValues[locale.languageCode]!['accountSettings']!;
  String get helpSupport => _localizedValues[locale.languageCode]!['helpSupport']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get faq => _localizedValues[locale.languageCode]!['faq']!;
  String get contactSupport => _localizedValues[locale.languageCode]!['contactSupport']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get logoutConfirmation => _localizedValues[locale.languageCode]!['logoutConfirmation']!;
  String get logoutMessage => _localizedValues[locale.languageCode]!['logoutMessage']!;
} 