import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: addressForm(),
            );
          });
    }
    final currentUser = Provider.of<AppUsers?>(context);
    return StreamProvider<UserProfile>.value(
      value: DatabaseService(uid: currentUser!.uid).useraccount,
      initialData: UserProfile.defaultInstance(),
      child: Scaffold(
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
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFF3C312B).withOpacity(0.75),
                    ),
                    SizedBox(width: 10,),
                    Text('Edit Location',
                      style: TextStyle(
                        color: Color(0xFF3C312B).withOpacity(0.75),
                      ),),
                  ],
                )),
            TextButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/cart');
                },
                icon: Icon(Icons.shopping_bag_outlined,
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
            PaymentPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}