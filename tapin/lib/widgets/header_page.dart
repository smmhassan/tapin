// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';
//
// import '../../icon_widget.dart';
//
// class HeaderPage extends StatelessWidget {
//   static const keyDarkMode = 'key-dark-mode';
//
//   @override
//   Widget build(BuildContext context) => Column(
//     children: [
//       buildHeader(),
//       const SizedBox(height: 32),
//       buildUser(context),
//       buildDarkMode(),
//     ],
//   );
//
//   Widget buildDarkMode() => SimpleSettingsTile(
//     title: 'Dark Mode',
//     settingKey: keyDarkMode,
//     leading: IconWidget(
//         icon: Icons.dark_mode,
//         color: Colors.(0xFF642ef3),
//   ),
//   onTap: () { /* DarkMode */}
//   );