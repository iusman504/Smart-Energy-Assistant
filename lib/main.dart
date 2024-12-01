import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:sea/firebase_options.dart';
import 'package:sea/res/colors.dart';
import 'package:sea/res/components/hide_snackbar.dart';
import 'package:sea/view_model/bill_view_model.dart';
import 'package:sea/view_model/home_view_model.dart';
import 'package:sea/view_model/signup_view_model.dart';
import 'package:sea/view/splash_view.dart';
import 'package:sea/view_model/login_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,

  ]);
  Gemini.init(apiKey: 'AIzaSyDCv1kjUsY-A347ZjZiUh3QNJTzd6A_XH8');
  runApp(

    const MyApp(),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => BillProvider()),
      ChangeNotifierProvider(create: (_) => SignupProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
    ],
    child: MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colours.kScaffoldColor,
      ),
      home: const SplashScreen(),
    ),);
  }
}
