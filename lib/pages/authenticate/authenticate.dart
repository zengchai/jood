import 'package:flutter/material.dart';
import 'package:jood/pages/authenticate/register.dart';
import 'package:jood/pages/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150,),
            Image.asset('assets/jood.png',
                width: 150,
                height: 200),
            SizedBox(height: 90,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/signin');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                    minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                  ),
                  child: Text("Sign In"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/signup');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF6B22D).withOpacity(0.75),),
                    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B)),
                    minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                  ),
                  child: Text("Sign Up"),
                ),
              ),
            ),
          ],
        ),
        ])

    );

  }
}
