import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderPage.dart';
import 'package:jood/pages/home/addressForm.dart';
import 'package:jood/pages/payment/payment.dart';
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showPanel() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Address'),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: addressForm(),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    ;

    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);

    if (currentUser!.uid == 'Pbzg09v1v5Q1ZrNLr92PyqxQ1QG2') {
      showCustomer = false;
    } else {
      showCustomer = true;
    }
    return StreamProvider<UserProfile>.value(
        value: DatabaseService(uid: currentUser!.uid).useraccount,
        initialData: UserProfile.defaultInstance(),
        child: showCustomer
            ?

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
                  actions: [
                    TextButton(
                        onPressed: () => _showPanel(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF3C312B).withOpacity(0.75),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Edit Location',
                              style: TextStyle(
                                color: Color(0xFF3C312B).withOpacity(0.75),
                              ),
                            ),
                          ],
                        )),
                    TextButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/cart');
                        },
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF3C312B).withOpacity(0.75),
                        ),
                        label: Text(''))
                  ],
                ),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    // Page 1 content
                    MenuPage(),
                    // Page 2 content

                    OrderPage(),
                    ProfilePage(),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavigationBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              )
            :

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
                    TextButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/cart');
                        },
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF3C312B).withOpacity(0.75),
                        ),
                        label: Text(''))
                  ],
                ),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    // Page 1 content
                    Payment(),
                    // Page 2 content

                    MenuPage(),
                    Container(
                      child: Center(
                        child: Text("data"),
                      ),
                    ),
                    ProfilePage(),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavigationBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              ));
  }
}
