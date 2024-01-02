import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class Register extends StatefulWidget {

  // final Function toggleView;
  // Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var iconColor1 = Color(0xFF7b5916).withOpacity(0.40);
  var iconColor2 = Color(0xFF7b5916).withOpacity(0.40);
  var iconColor3 = Color(0xFF7b5916).withOpacity(0.40);
  bool focus = false;
  bool loading = false;
  String email = '';
  String name = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
              child: Form(
                key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              "Discover a world of flavors at your fingertips!",
                              style: TextStyle(
                                fontSize: 13
                                ,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor1 = hasFocus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.40); // Unfocused color
                      });
                    },
                    child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            labelStyle: TextStyle(color: iconColor1),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.people,
                              color: iconColor1,),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.25), width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.75), width: 2.0)
                            )
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an name': null,
                        onChanged: (value){
                          setState(() {
                            name = value;
                          });
                        },
                    )),
                      SizedBox(height: 15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        focus = hasFocus;
                        iconColor2 = focus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.40); // Unfocused color
                      });
                    },
                    child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: iconColor2),
                          fillColor: Colors.white,
                            prefixIcon: Icon(Icons.email,
                              color: iconColor2,),
                          filled: true,

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.25), width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.75), width: 2.0)
                            )
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an email': null,
                        onChanged: (value){
                          setState(() {
                            email = value;
                          });
                        },
                      )),
                      SizedBox(height: 15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor3 = hasFocus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.40); // Unfocused color
                      });
                    },
                    child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: iconColor3),
                              fillColor: Colors.white,
                              filled: true,// Add your placeholder text
                              prefixIcon: Icon(Icons.lock,
                                color: iconColor3,),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.25), width: 2.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF7b5916).withOpacity(0.75), width: 2.0)
                              )
                          ),
                          validator: (val) => val!.length<6 ? 'Enter a password 6+ chars long': null,
                          obscureText: true,
                          onChanged: (val){
                            setState(() {
                              password = val;
                            });
                          }
                      )),
                      SizedBox(height:50.0),
                      ElevatedButton(
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, context);
                            if(result == null){
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
                              });
                            }
                            else {
                              print('Navigating to register screen.');
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF6B22D).withOpacity(0.75),),
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B)),
                          minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  )
              )),
        ])
    );
  }
}
