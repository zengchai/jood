import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderPage.dart';
import 'package:jood/pages/home/addressForm.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/services/auth.dart';
import 'package:jood/services/database.dart';
import 'package:provider/provider.dart';

import '../../constants/navBar.dart';
import '../../models/users.dart';
import '../menu/menu.dart';
import '../profile/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> foodReviews = [];

  int _selectedIndex = 0;
  TextEditingController addressController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAddressController();
  }

  Future<void> _initializeAddressController() async {
    final currentUser = Provider.of<AppUsers?>(context, listen: false);

    if (currentUser != null) {
      final userProfile = await DatabaseService(uid: currentUser?.uid ?? '').getUserProfile(currentUser?.uid ?? '');

      if (addressController != null) {
        setState(() {
          addressController.text = userProfile?.address ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showPanel() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delivery Address'),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    child: addressForm(),
                  )
                ],
              ),
            ),
          );
        },
      );
    };

    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);
    final DatabaseService databaseService = DatabaseService(uid: currentUser!.uid);
    if (currentUser == null) {
      child: CircularProgressIndicator();
      return Container(); // or return some placeholder widget
    }

    if (currentUser.uid == 'TnDmXCiJINXWdNBhfZvuAFCuaSL2') {
      showCustomer = false;
    } else {
      showCustomer = true;
    }

    return StreamProvider<UserProfile>.value(
      value: DatabaseService(uid: currentUser!.uid).useraccount,
      initialData: UserProfile.defaultInstance(),
      catchError: (context, error) {
        // Handle the error, e.g., show an error message or log the error
        print('Error in StreamProvider: $error');
        return UserProfile.defaultInstance(); // Provide a default value
      },
      child: Consumer<UserProfile>(
        builder: (context, userProfile, _) {
          // Update addressController when userProfile changes
          addressController.text = userProfile.address ?? '';

          return showCustomer ?

          // If he/she is a customer
          Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              leadingWidth: 120,
              leading: Container(
                padding: EdgeInsets.symmetric(vertical: 19, horizontal: 19),
                child: Image.asset(
                  'assets/icon.png',
                  width: 50, // adjust the width as needed
                  height: 50, // adjust the height as needed
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: <Widget>[
                TextButton(
                    onPressed: () => _showPanel(),
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF3C312B).withOpacity(0.75),
                          ),
                          SizedBox(width: 14,),
                          Text(
                            addressController.text.length > 14
                                ? '${addressController.text.substring(0, 14)}...' // Display first 20 characters
                                : addressController.text,
                            style: TextStyle(
                              color: Color(0xFF3C312B).withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    )),
                FutureBuilder<bool>(
                  future: databaseService.isCartNotEmpty(), // Assume you have a function to check if the cart is not empty
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the Future is still running, display a loading indicator
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If there's an error, handle it accordingly
                      return Icon(Icons.error);
                    } else {
                      // If the cart is not empty, show the filled cart icon, otherwise, show the empty cart icon
                      return TextButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/cart');
                        },
                        icon: Icon(
                          snapshot.data ?? false
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                          color: Color(0xFF3C312B).withOpacity(0.75),
                        ),
                        label: Text(''),
                      );
                    }
                  },
                ),
              ],
            ),
            body: FutureBuilder<bool>(
              future: databaseService.isCartNotEmpty(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // Page 1 content
                      MenuPage(foodReviews: foodReviews,onCartUpdated: () {
                        // Trigger a rebuild when the cart is updated
                        setState(() {});
                      },),
                      // Page 2 content
                      OrderPage(),
                      ProfilePage(),
                    ],
                  );
                }
              },
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ):

          // If he/she is a seller
          Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              leadingWidth: 120,
              leading: Container(
                padding: EdgeInsets.symmetric(vertical: 19, horizontal: 19),
                child: Image.asset(
                  'assets/icon.png',
                  width: 50, // adjust the width as needed
                  height: 50, // adjust the height as needed
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: <Widget>[
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                // Page 1 content
                MenuPage(foodReviews: foodReviews,onCartUpdated: () {
              // Trigger a rebuild when the cart is updated
              setState(() {});
          },),
                // Page 2 content
                OrderPage(),
                ProfilePage(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          );
        },
      ),
    );
  }
}
