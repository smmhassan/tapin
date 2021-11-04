import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/auth/auth_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/home/home_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/login/login_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/signup/signup_bloc.dart';
import 'package:customer_service/screens/userchats/lib/repositories/message_repos.dart';
import 'package:customer_service/screens/userchats/lib/repositories/user_repos.dart';
import 'package:customer_service/screens/userchats/lib/root.dart';
import 'package:customer_service/screens/userchats/lib/screens/home.dart';
import 'package:customer_service/screens/userchats/lib/screens/login.dart';
import 'package:customer_service/screens/userchats/lib/screens/signup.dart';
import 'package:customer_service/screens/userchats/lib/widgets/button_widget.dart';

class ScreenArgument {}

class ScreenRouter {
  static const ROOT = '/';
  static const HOME = 'home';
  static const LOGIN = 'login';
  static const REGISTER = 'register';

  var userRepo, messageRepo;

  ScreenRouter() {
    userRepo = UserRepository();
    messageRepo = MessageRepository();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var route = buildPageRoute(settings);
    Map arguments = settings.arguments;

    switch (settings.name) {
      case ROOT:
        return route(Root());
      case REGISTER:
        return route(SignUpScreen());
      case LOGIN:
        return route(LoginScreen());
      case HOME:
        return route(HomeScreen());
      default:
        return unknownRoute(settings);
    }
  }

  Function buildPageRoute(RouteSettings settings) {
    var blocProviders = [
      BlocProvider(create: (context) => AuthCubit(userRepository: userRepo)),
      BlocProvider(
          create: (context) => HomeCubit(messageRepository: messageRepo)),
      BlocProvider(
        create: (context) => LoginCubit(
          userRepository: userRepo,
        ),
      ),
      BlocProvider(
        create: (context) => SignupCubit(
          userRepository: userRepo,
        ),
      )
    ];

    return (Widget child, {fullScreen = false}) => MaterialPageRoute(
          fullscreenDialog: fullScreen,
          builder: (context) => MultiBlocProvider(
            providers: blocProviders,
            child: child,
          ),
          settings: settings,
        );
  }

  Route<dynamic> unknownRoute(RouteSettings settings) {
    var unknownRouteText = "No such screen for ${settings.name}";

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unknownRouteText),
          Padding(padding: const EdgeInsets.all(10.0)),
          ButtonWidget(
            title: "Back",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
