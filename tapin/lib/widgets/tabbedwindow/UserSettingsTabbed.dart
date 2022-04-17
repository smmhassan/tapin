
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import '../account_page.dart';
import '../icon_widget.dart';


Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());

  runApp(UserSettings());
}

class UserSettings extends StatefulWidget{
  static final String title = 'Settings';
  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          SettingsGroup(
            title: 'GENERAL',
            children: <Widget>[
              AccountPage(),
              buildLogout(),
              buildDeleteAccount(),
            ],
          ),
          SettingsGroup(
            title: 'FEEDBACK',
            children: <Widget>[
              buildReportBug(context),
              buildSendFeedback(context),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildLogout() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: '',
      leading: IconWidget(
        icon: Icons.logout,
        color: Colors.blueAccent,
      ),
      onTap: () { /* logout */}
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: IconWidget(icon: Icons.delete,color: Colors.redAccent,      ),
    //onTap: () => Utils.showSnackBar(context, 'Clicked Delete Account'),
  );

  Widget buildAccount() => SimpleSettingsTile(
      title: 'Account Settings',
      subtitle: 'Privacy, Security, Language',
      leading: IconWidget(
        icon: Icons.person,
        color: Colors.green,
      ),
      child: Container(),
      onTap: () { /* logout */}
  );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
    title: 'Report A Bug',
    subtitle: '',
    leading: IconWidget(icon: Icons.bug_report, color: Colors.teal),
    //OnTap: () => Utils.showSnackBar(context, 'Clicked Report A Bug'),
  );

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
    title: 'Send Feedback',
    subtitle: '',
    leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
    //OnTap: () => Utils.showSnackBar(context, 'Clicked Send Feedback'),
  );

}