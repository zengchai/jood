// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    //Date
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    return Scaffold(
      backgroundColor: Colors.white,

      //body============================================
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text customer's order==========================
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CUSTOMER'S ORDER",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Date calender===================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        formattedDate, // Replace with your dynamic date
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //Tab navigation button
            //=====================================================
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Incoming'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Ongoing'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('History'),
                  ),
                ],
              ),
            ),

            //orders card============================================
            // Boxes or Cards under buttons

            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 160,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 193, 142, 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 232, 209, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 160,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 193, 142, 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 232, 209, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 160,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 193, 142, 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 232, 209, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 160,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 193, 142, 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 232, 209, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
