import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jood/firebase_options.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/authenticate/authenticate.dart';
import 'package:jood/pages/authenticate/register.dart';
import 'package:jood/pages/authenticate/sign_in.dart';
import 'package:jood/pages/home/home.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/pages/wrapper.dart';
import 'package:jood/services/auth.dart';
import 'package:provider/provider.dart';

import 'pages/menu/provider/menu_provider/menu_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure WidgetsBinding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase


runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUsers?>.value(
      catchError: (User,user) {},
      value: AuthService().changeuser,
      initialData: null,
      child: MaterialApp(
        routes: {'/authenticate': (context) => Authenticate(),
          '/home': (context) => Home(),
          '/signin': (context) => SignIn(),
          '/signup': (context) => Register(),
          '/cart': (context) => Payment(),


        },
        home: const Wrapper(),
      ),
    );
  }
}
