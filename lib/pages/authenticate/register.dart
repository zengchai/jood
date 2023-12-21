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
  var iconColor1 = Color(0xFF7b5916).withOpacity(0.25);
  var iconColor2 = Color(0xFF7b5916).withOpacity(0.25);
  var iconColor3 = Color(0xFF7b5916).withOpacity(0.25);

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
          backgroundColor: Color(0xFF7b5916).withOpacity(0.75),
          elevation: 0.0,
          title: Text("Sign Up"),
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
                      Icon(
                        Icons.perm_identity_rounded,
                        size: 60,
                        color: Colors.black,
                      ),
                      SizedBox(height: 50.0),
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor1 = hasFocus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.25); // Unfocused color
                      });
                    },
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Name', // Add your placeholder text
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
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor2 = hasFocus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.25); // Unfocused color
                      });
                    },
                    child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email', // Add your placeholder text
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
                  Focus(
                    onFocusChange: (hasFocus) {
                      // Use the hasFocus value to determine whether the field is focused
                      setState(() {
                        iconColor3 = hasFocus
                            ? Color(0xFF7b5916).withOpacity(0.75) // Focused color
                            : Color(0xFF7b5916).withOpacity(0.25); // Unfocused color
                      });
                    },
                    child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Password',
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
                          minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Text(
                        error,
                      )
                    ],
                  )
              )),
        ])
    );
  }
}
