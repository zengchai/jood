import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/authenticate/authenticate.dart';
import 'package:jood/pages/home/home.dart';
import 'package:provider/provider.dart';
import 'home/adminHome.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUsers?>(context);
    if (currentUser == null){
      return Authenticate();
    }
    else{
    if(currentUser!.uid =='Pbzg09v1v5Q1ZrNLr92PyqxQ1QG2'){
    return AdminHome();
    }
    else{
      print('User detected. Navigating to Home screen.');
      return Home();
    }}
}}