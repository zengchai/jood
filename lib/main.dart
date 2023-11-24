import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jood/firebase_options.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/authenticate/authenticate.dart';
import 'package:jood/pages/authenticate/register.dart';
import 'package:jood/pages/authenticate/sign_in.dart';
import 'package:jood/pages/home/home.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/pages/profile/editprofile.dart';
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
          '/editprofile': (context) => EditProfile(),

        },
        home: Wrapper(),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/userprofile.dart';
// import '../../models/users.dart';
// import '../../services/database.dart';
// import '../../shared/loading.dart';
//
// class addressForm extends StatefulWidget {
//   const addressForm({Key? key}) : super(key: key);
//
//   @override
//   State<addressForm> createState() => _addressFormState();
// }
//
// class _addressFormState extends State<addressForm> {
//
//   final _formKey = GlobalKey<FormState>();
//   late final String address;
//   TextEditingController addressController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return
//           Column(
//               children: <Widget>[
//           FutureBuilder<UserProfile?>(
//             // Use FutureBuilder to wait for the Future<UserProfile> to complete
//               future: DatabaseService(uid: Provider.of<AppUsers?>(context)!.uid)
//                   .getUserProfile(Provider.of<AppUsers?>(context)!.uid),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Return a loading indicator while waiting for the Future to complete
//                   return Text('hi');
//                 } else if (snapshot.hasError) {
//                   // Handle errors if the Future completes with an error
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   // Use the UserProfile once the Future is complete
//                   UserProfile user = snapshot.data!;
//                   addressController.text = '${user.address}';
//
//                   return Form(
//                       key: _formKey,
//                       child:Column(
//                           children: <Widget>[
//                             SizedBox(height: 35,),
//                             TextFormField(
//                               controller: addressController,
//                               decoration: InputDecoration(
//                                   hintText: 'Address',
//                                   // Add your placeholder text
//                                   fillColor: Colors.white,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                       // Set the border radius here
//                                       borderSide: BorderSide(color: Color(0xFFF6B22D)
//                                           .withOpacity(0.25), width: 2.0)
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12.0),
//                                       // Set the border radius here
//                                       borderSide: BorderSide(color: Color(0xFFF6B22D)
//                                           .withOpacity(0.75), width: 2.0)
//                                   )
//                               ),
//                               validator: (val) =>
//                               val!.isEmpty
//                                   ? 'Enter an address'
//                                   : null,
//                             ),
//                             SizedBox(height: 50,),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 await DatabaseService(uid: Provider.of<AppUsers?>(
//                                     context)!.uid).updateAddressData(address);
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(
//                                   Color(0xFFF6B22D).withOpacity(0.75),),
//                                 foregroundColor: MaterialStateProperty.all<Color>(
//                                     Color(0xFF3C312B)),
//                                 minimumSize: MaterialStateProperty.all<Size>(
//                                     Size(200, 50)),
//                               ),
//                               child: Text(
//                                 'Update',
//                                 style: TextStyle(
//                                   fontSize: 15.0,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                 }
//               }
//               )
//               ]
//           );
//   }
// }
