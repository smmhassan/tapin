import 'package:tapin/widgets/icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccountPage extends StatelessWidget{
  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';
  static const keyPassword = 'key-password';


  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
    title: 'Account Settings',
    subtitle: 'Privacy, Security, Language',
    leading: IconWidget(icon: Icons.person, color: Colors.green),
    child: SettingsScreen(
      title: 'Account Settings',
      children: <Widget>[
        buildLanguage(),
        buildPassword(),
        buildLocation(),
        buildPrivacy(context),
        buildSecurity(context),
        buildAccountInfo(context),
      ],
    ),
  );

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
    title: 'Privacy',
    subtitle: '',
    leading: IconWidget(icon: Icons.lock, color: Colors.blue),
    //OnTap: () => Utils.showSnackBar(context, 'Clicked Privacy'),
  );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
    title: 'Security',
    subtitle: '',
    leading: IconWidget(icon: Icons.security, color: Colors.redAccent),
    //OnTap: () => Utils.showSnackBar(context, 'Clicked Security'),
  );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
    title: 'Account Info',
    subtitle: '',
    leading: IconWidget(icon: Icons.text_snippet, color: Colors.purple),
    //OnTap: () => Utils.showSnackBar(context, 'Clicked Account Info'),
  );

  Widget buildLocation() => TextInputSettingsTile(
      title: 'Location',
      settingKey: keyLocation, // static const keyLanguage = 'key-language';
      initialValue: 'Galesburg',
      onChange: (location) { /* code and shit */}
  );

  Widget buildLanguage() => DropDownSettingsTile(
      title: 'Language',
      settingKey: keyLanguage, //static const keyLanguage = 'key-language';
      selected: 1,
      values: <int, String>{
        1: 'English',
        2: 'Chinese'
      },
      onChange: (language) { /* code and shit */}
  );

  Widget buildPassword() => TextInputSettingsTile(
      settingKey: keyPassword,
      title: 'Password',
      obscureText: true,
      validator: (password) => password != null && password.length >= 6
          ? null
          : 'Enter 6 characters'
  );
}