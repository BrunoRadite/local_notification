import 'package:flutter/material.dart';
import '../main.dart';

class Routes {
  ///mapa que liga uma rota a uma tela
  static Map<String, Widget Function(BuildContext)> mapRoutes =
      <String, WidgetBuilder>{
    ///ligando a tela MyHomePage a rota /home
    '/home': (_) => const MyHomePage(
          title: 'My home page',
        ),

    ///caso tenha outra tela só repetir o processo com o nome da rota que desejar
  };

  ///definindo uma rota inicial para colocar na main
  static String initial = '/home';

  ///permite o acesso a navegação em qualquer lugar do app
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
