import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jood/firebase_options.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/authenticate/authenticate.dart';
import 'package:jood/pages/authenticate/register.dart';
import 'package:jood/pages/authenticate/sign_in.dart';
import 'package:jood/pages/home/home.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/pages/payment/payment2.dart';
import 'package:jood/pages/payment/payment3.dart';
import 'package:jood/pages/profile/profile.dart';
import 'package:jood/pages/shoppingcart/cart.dart';
import 'package:jood/pages/wrapper.dart';
import 'package:jood/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure WidgetsBinding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
   runApp(MyApp());
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
          '/method': (context) => MethodPage(),
          '/receipt': (context) => Receipt(),


        },
        home: Wrapper(),
      ),
    );
  }
}
