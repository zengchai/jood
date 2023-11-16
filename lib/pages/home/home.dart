import 'package:flutter/material.dart';
import 'package:jood/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/menu');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/payment');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                await _auth.signOut();
              },
              icon: Icon(Icons.people),
              label: Text('Logout'))
        ],
      ),
      //bottomNavigationBar=============================
      bottomNavigationBar: Container(
        height: 70.0, //height of bar
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.5), width: 0.5),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'MENU',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'ORDER',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'ME',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
