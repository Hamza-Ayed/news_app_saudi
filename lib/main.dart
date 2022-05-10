import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'provider/provider.dart';
// import 'package:workmanager/workmanager.dart';

// const fetchBackground = "fetchBackground";
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     switch (taskName) {
//       case Workmanager.iOSBackgroundTask:
//         NewsProvider().getHaber();
//         break;
//     }
//     return Future.value(true);
//   });
// }

void main() {
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );

  // Workmanager().registerPeriodicTask(
  //   "1",
  //   fetchBackground,
  //   frequency: const Duration(minutes: 4),
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
  final cron = Cron();
  cron.schedule(Schedule.parse('*/5 * * * *'), () async {
    NewsProvider().getHaber();
    print('every one minutes');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golenci',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
