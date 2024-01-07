import 'package:flutter/material.dart';
import 'package:jood/pages/profile/deleteconfirmation.dart';
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
    void _showPanel() {
      showDialog(
        context: context,
        builder: (context) {
          return deleteConfirmation(title: "Delete", subtitle: "Do you want to delete your account?");
        },
      );
    };
    return showCustomer?

    // If he/she is a customer
    Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFF3C312B).withOpacity(0.25),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF3C312B).withOpacity(0.75),
                            size: 45,
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
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/editprofile');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75)),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Edit profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: ElevatedButton(
                      onPressed: () async{
                        _showPanel();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.block,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Delete account',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: ElevatedButton(
                      onPressed: () async{
                        await _auth.signOut(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
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
                    await _auth.signOut(context);
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
