import 'package:flutter/material.dart';
import 'package:notification_bar/models/notification_model.dart';
import 'package:notification_bar/routes/routes.dart';
import 'package:notification_bar/services/notification_service.dart';
//importe do provider
import 'package:provider/provider.dart';

void main() {
  //garante que todas as widgets sejam carregadas corretamente
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      //envolvi o const MyApp() com o MultiProvider para inicializar o nosso service de notificação
      MultiProvider(providers: [
    Provider<NoticationService>(
      create: ((context) => NoticationService()),
    )
  ], child: const MyApp()));
}

//mudei de Stateless para Stateful para ter acesso ao initState
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //criei o metodo initstate para caso o app seja fechado e aberto pela notificacao ele vá para a pagina certa
  @override
  initState() {
    super.initState();
    _checkNotification();
  }

  _checkNotification() async {
    await Provider.of<NoticationService>(context, listen: false)
        .checkForNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //antes era:
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      //agora será assim para funcionar o sistema de rotas
      routes: Routes.mapRoutes,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      //vamos chamar nossa notificação
      Provider.of<NoticationService>(context, listen: false)
          .showNotification(NotificationModel(
              //coloquei um id fixo pois será atualizado e a notificação sempre estará correta
              //se colocar um id diferente exempo _couter ele gera uma fila de notificações
              id: 1,
              body: 'O valor agora é $_counter',
              payload: '/home',
              title: 'Valor mudado'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
