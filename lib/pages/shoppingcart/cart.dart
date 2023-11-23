import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _PaymentState();
}

class _PaymentState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7b5916).withOpacity(0.75),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Text("payment"),
    );
  }
}
