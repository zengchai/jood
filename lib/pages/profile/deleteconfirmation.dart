import 'package:flutter/material.dart';

import '../../services/auth.dart';

class deleteConfirmation extends StatefulWidget {
  final String title;
  final String subtitle;
  const deleteConfirmation({required this.title,required this.subtitle});

  @override
  State<deleteConfirmation> createState() => _deleteConfirmationState();
}

class _deleteConfirmationState extends State<deleteConfirmation> {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String subtitle = widget.subtitle;

    return AlertDialog(
      titlePadding: EdgeInsets.symmetric(vertical: 30),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
        Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Center(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
            SizedBox(height: 30,),
          Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                    child: Text(subtitle,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _auth.deleteUserAccount(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75)),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ])));
  }
}
