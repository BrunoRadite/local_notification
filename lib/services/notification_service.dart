import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_bar/models/notification_model.dart';

import '../routes/routes.dart';

class NoticationService {
  ///por meio desse plugin conseguiremos chamar a notificação(será preenchido depois)
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  ///detalhes da notificação no Android(será preenchido depois)
  late AndroidNotificationDetails androidNotificationDetails;

  ///construindo nossa classe
  NoticationService() {
    ///atribuindo um valor para o nosso [localNotificationsPlugin]
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _setupNotifications();
  }

  ///fazer um setup das notificações
  _setupNotifications() async {
    await _initialNotifications();
  }

  ///inicializar as configurações das notificações
  _initialNotifications() async {
    ///para as configurações padrões da notificação basicamente temos que passar somente
    ///o icone do app ['@mipmap/ic_launcher']
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    //Fazer: macOS,iOS ou Linux.

    ///inicializando agora o nosso [localNotificationsPlugin]
    await localNotificationsPlugin.initialize(
        //aqui você configura para cada plataforma em seu determinado atributo
        const InitializationSettings(android: android),

        //quando o usuario clicar na notificação
        onDidReceiveNotificationResponse: (response) =>
            _onSelectionNotification(response.payload));
  }

  //metodo e lógica do atributo onDidReceiveNotificationResponse
  _onSelectionNotification(String? payload) {
    //Se tiver payload vamos para a pagina especifica
    if (payload != null && payload.isNotEmpty) {
      //aqui chamamos nossa navigatorKey assim teremos acesso ao contexto de navegação pela notificação
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushReplacementNamed(payload);
    }
  }

  ///metodo que chama e mostra a notificação
  showNotification(NotificationModel notification) {
    ///atribuindo valor ao metodo [androidNotificationDetails]
    androidNotificationDetails = const AndroidNotificationDetails(
        //aqui é o id do channel, não é o da notificação
        'notificao_clique',
        //Nome do channel
        'Cliques',
        channelDescription: 'Este canal é chamado quando eu clico em algo',
        //Caso seja .max a notificação aparecerá em forma de pop up antes de ir para barra de notificação
        importance: Importance.max,
        //Caso seja .max a notificação sempre ficará pelo topo da barra de notificação
        priority: Priority.max,
        //vibração
        enableVibration: true);

    //chama e mostra a notificação
    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        //aqui você configura para cada plataforma em seu determinado atributo
        NotificationDetails(android: androidNotificationDetails),
        //passa o payload
        payload: notification.payload);
  }

  //verifica se o aplicativo possui notificações pendentes quando o app foi fechado
  checkForNotification() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectionNotification(details.notificationResponse!.payload);
    }
  }
}
