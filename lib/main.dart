import 'package:flutter/material.dart';
import 'package:todays_task_list/screens/webview_screen.dart';


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 4));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today Task List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebviewScreen(url: "http://todaystasklist.com/members/"),
    );
  }
}
//ablegodxpress.com