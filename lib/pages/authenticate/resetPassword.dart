import "package:flutter/material.dart";

import "../../services/auth.dart";

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _auth = AuthService();
  var iconColor = Color(0xFF3C312B).withOpacity(0.40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(
            color: Colors.black, // Set the color you want for the back button
          ),
          actions: <Widget>[],
        ),
        body: ListView(
          children: [Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        "Key in your email to reset your password.",
                        style: TextStyle(
                          fontSize: 13
                          ,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60.0),
                Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor = hasFocus
                            ? Color(0xFF3C312B).withOpacity(0.75) // Focused color
                            : Color(0xFF3C312B).withOpacity(0.40); // Unfocused color
                      });
                    },
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: iconColor),
                          prefixIcon: Icon(Icons.email,
                            color: iconColor,), // Email icon
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.25), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                    )),
                SizedBox(height: 60.0),
                ElevatedButton(
                  onPressed: () {
                    _auth.resetPassword(_emailController.text,context);
                  },style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                  foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                ),
                  child: Text('Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ])
    );
  }
}

