import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_v2/data/data.dart';
import 'package:todo_v2/screens/home/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PeriorityAdapter());
  await Hive.openBox("taskBox");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff794CFF),
      statusBarIconBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        colorScheme: const ColorScheme.light(
            primary: Color(0xff794CFF),
            secondary: Color(0xff5C0AFF),
            onSecondary: Colors.white,
            background: Color(0xffF3F5F8),
            onSurface: Color(0xff1d2830),
            onBackground: Color(0xffAFBED0),
            onPrimary: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
