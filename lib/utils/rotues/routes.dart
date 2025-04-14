import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iplayer/utils/rotues/routes_name.dart';
import 'package:iplayer/view/onboarding_screen.dart';
import '../../view/Splash_Screen.dart';
import '../../view/login_screen.dart';
import '../../view/video_player_screen.dart';

class Routes {

    static Route<dynamic>  generateRoutes(RouteSettings settings){

      final argume = settings.arguments ;

      switch(settings.name){

        case  RoutesName.splash:

          return MaterialPageRoute(builder: (BuildContext context )=> SplashScreen()) ;

        case  RoutesName.onboarding:

          return MaterialPageRoute(builder: (BuildContext context )=> OnboardingScreen()) ;
        case  RoutesName.home:

          return MaterialPageRoute(builder: (BuildContext context )=> VideoApp()) ;

        case  RoutesName.login:

          return MaterialPageRoute(builder: (BuildContext context )=> LoginScreen()) ;

        default:
          return MaterialPageRoute(builder: (_){
             return Scaffold(
               body: Center(child: Text("No Route Defined"),),
             );
          });
      }
    }
}