// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class OrderItem {
  final String orderID;
  final String name;
  final String image;
  int quantity;
  final double price;
  final String status;

  OrderItem({
    required this.orderID,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

class _OrderPageState extends State<OrderPage> {
  List<OrderItem> orderItems = [
    OrderItem(
        orderID: '#1234',
        name: 'Fried Mee',
        image: 'assets/friedmee.jpeg',
        quantity: 2,
        price: 7.0,
        status: 'Order Preparing'),
    OrderItem(
        orderID: '#5678',
        name: 'Fried Rice',
        image: 'assets/friedrice.jpeg',
        quantity: 1,
        price: 6.0,
        status: 'Order Preparing'),
  ];

//Date
  late DateTime currentDate = DateTime.now();
  late String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MY ORDER",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        formattedDate,
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  // ListView.builder to dynamically create order item cards
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildOrderItemCard(orderItems[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItem orderItem) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
            height: 32,
            width: 400,
            decoration: BoxDecoration(
              color: Color.fromRGBO(226, 193, 142, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Text('${orderItem.orderID}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: Color.fromRGBO(248, 232, 209, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(8), // Adjusted content padding
              leading: Image.asset(
                orderItem.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(orderItem.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${orderItem.quantity}'),
                      Text('Price: \$${orderItem.price.toStringAsFixed(2)}'),
                      Text('Status: ${orderItem.status}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
