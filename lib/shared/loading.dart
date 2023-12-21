import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 80, // adjust the width as needed
              height: 80, // adjust the height as needed
            ),
            SizedBox(height: 40,),
            SpinKitThreeBounce(
              color: Colors.brown[800],
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}