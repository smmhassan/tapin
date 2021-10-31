import 'package:customer_service/constants.dart';
import 'package:customer_service/screens/chats/localwidgets/ChatUI.dart';
import 'package:customer_service/screens/signup/localwidgets/passwordResetScreen.dart';
import 'package:customer_service/utils/OurTheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'screens/login/login.dart';
import 'screens/userdash/userdash.dart';
import 'screens/userlists/organizations.dart';
import 'screens/userlists/correspondences.dart';
import 'screens/userorganization/userorganization.dart';
import 'screens/chats/chatScreen.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:customer_service/services/graphQLConf.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = kParseApplicationId;
  final keyClientKey = kParseClientKey;
  final keyParseServerUrl = kUrl;
  final keyLiveQueryUrl = kLiveUrl;

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      liveQueryUrl: keyLiveQueryUrl,
      autoSendSessionId: true);
  /*var firstObject = ParseObject('FirstClass')
    ..set(
        'message', 'Hey ! First message from Flutter. Parse is now connected');
  await firstObject.save();

  print('done');  */ //Uncomment to test connection
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  //get typenameDataIdFromObject => null; //look into actual fix
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OurTheme().buildTheme(),
      //home:
      // OurLogin(),
      routes: {
        '/': (context) => ChatScreen(),
        //'/': (context) => UserOrganizationList(),
        '/userdash': (context) => UserDash(),
        '/userorganizations': (context) => UserOrganizationList(),
        '/usercorrespondences': (context) => UserCorrespondenceList(),
        '/userorganization': (context) => UserOrganization(),
        '/resetpasswordscreen': (context) => OurPasswordResetScreen(),
      },
    );
  }
}
