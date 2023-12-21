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
  var iconColor = Color(0xFF3C312B).withOpacity(0.10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3C312B).withOpacity(0.80),
          elevation: 0.0,
          title: Text("Forgot Password"),
          actions: <Widget>[],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              Focus(
                  onFocusChange: (hasFocus) {
                    // Use the hasFocus value to determine whether the field is focused
                    setState(() {
                      iconColor = hasFocus
                          ? Color(0xFF3C312B).withOpacity(0.75) // Focused color
                          : Color(0xFF3C312B).withOpacity(0.10); // Unfocused color
                    });
                  },
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Email', // Add your placeholder text
                        prefixIcon: Icon(Icons.email,
                          color: iconColor,), // Email icon
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                        )
                    ),
                  )),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  _auth.resetPassword(_emailController.text,context);
                },style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
              ),
                child: Text('Send',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
    );
  }
}

