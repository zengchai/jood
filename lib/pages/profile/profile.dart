import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/userprofile.dart';
import '../../models/users.dart';
import '../../services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _PaymentState();
}

class _PaymentState extends State<ProfilePage> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfile>(context);

    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);

    if(currentUser!.uid =='TnDmXCiJINXWdNBhfZvuAFCuaSL2'){
      showCustomer = false;
    } else {
      showCustomer = true;
    }

    return showCustomer?

    // If he/she is a customer
    Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 45,),
                  Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFF3C312B).withOpacity(0.25),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF3C312B).withOpacity(0.75),
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          '${profile.name}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ]
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () async{
                      await Navigator.pushNamed(context, '/editprofile');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                    ),
                    child: Text(
                      'Edit profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async{
                      await _auth.deleteUserAccount(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                    ),
                    child: Text(
                      'Delete account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async{
                      await _auth.signOut();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                    ),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],

    ),):

    // If he/she is an admin
    Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 45,),
                Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF3C312B).withOpacity(0.25),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF3C312B).withOpacity(0.75),
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        '${profile.name}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ]
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () async{
                    await _auth.signOut();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                    minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],

      ),);
  }
}
