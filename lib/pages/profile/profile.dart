import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/userprofile.dart';
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
    return Scaffold(
        backgroundColor: Colors.brown[50],
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 45,),
                  Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF3C312B).withOpacity(0.25),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF3C312B).withOpacity(0.75),
                            size: 60,
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
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                    ),
                    child: Text(
                      'Sign In',
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

    ),);
  }
}
