import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/auth/login/login_screen.dart';
import 'package:todo_app/home/auth/register/register_screen.dart';
import 'package:todo_app/home/homescreen.dart';
import 'package:todo_app/my_theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_config_provider.dart';
import 'package:todo_app/list_provider.dart';
import 'package:todo_app/user_provider.dart';


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDpULVF74kPLEYnymvIYoweSlT7gytI8bc",
          appId: "com.example.to_do_list",
          messagingSenderId: "357299021125",
          projectId: "to-do-app-aa778"))
      : await Firebase.initializeApp();
 // await FirebaseFirestore.instance.disableNetwork() ;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppConfigProvider() ,
    ) ,
      ChangeNotifierProvider(
        create: (context) => ListProvider(),
      ) ,
    ChangeNotifierProvider(
      create: (context) => UserProvider() ,
    ) ,


  ],

      child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context) ;
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      initialRoute: LoginScreen.routeName ,
      routes: {

        HomeScreen.routeName : (context) => HomeScreen(),
        RegisterScreen.routeName : (context) => RegisterScreen() ,
        LoginScreen.routeName : (context) => LoginScreen(),
      },
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: provider.appTheme,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
