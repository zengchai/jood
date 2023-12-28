// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/Order/orderItem.dart';
import 'package:jood/pages/Order/reviewForm.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/services/auth.dart';
import 'package:jood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../menu/provider/menu_provider/menu_provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late final String review;
  int _currentPageIndex = 0;

  void _popupReview(OrderItem orderItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Review'),
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                            orderItem.foodImage,
                            width: 120,
                            height: 120,
                          ),
                          title: Text(orderItem.foodName),
                          subtitle: Text(orderItem.price.toStringAsFixed(2)),
                        ),
                        SizedBox(height: 20),
                        ReviewForm(foodID: orderItem.foodID, orderID: orderItem.orderID,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Date picker for filter
  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    // Check if the user picked a date or canceled
    if (pickedDate != null) {
      // User picked a date
      setState(() {
        // Exclude the time component
        selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });

// Update formattedDate
      formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    } else {
      // User canceled the operation
      // You can handle this case as needed, e.g., do nothing or show a message
      print('Date picking canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);
    DatabaseService databaseService = DatabaseService(uid: currentUser!.uid);

    if (currentUser!.uid == 'TnDmXCiJINXWdNBhfZvuAFCuaSL2') {
      showCustomer = false;
    } else {
      showCustomer = true;
    }


    return Scaffold(
        backgroundColor: Colors.white,
        body: showCustomer
            ?
            //if he/she is customer
            Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                            MaterialButton(
                              onPressed: _showDatePicker,
                              padding: EdgeInsets.zero,
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      children: [
                        StreamBuilder<List<OrderItem>>(
                            // stream: DatabaseService(uid: currentUser!.uid)
                            stream: DatabaseService(uid: currentUser!.uid)
                                .getCustomerOrder(formattedDate),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No order available",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                List<OrderItem> allOrderItems =
                                    snapshot.data ?? [];

                                // Group order items by order ID
                                Map<String, List<OrderItem>> groupedOrders = {};

                                for (var orderItem in allOrderItems) {
                                  if (!groupedOrders
                                      .containsKey(orderItem.orderID)) {
                                    groupedOrders[orderItem.orderID] = [];
                                  }
                                  groupedOrders[orderItem.orderID]!
                                      .add(orderItem);
                                }

                                return ListView.builder(
                                  itemCount: groupedOrders.length,
                                  itemBuilder: (context, index) {
                                    String orderID =
                                        groupedOrders.keys.elementAt(index);
                                    List<OrderItem> orderItems =
                                        groupedOrders[orderID] ?? [];
                                    String status = orderItems.isNotEmpty
                                        ? orderItems[0].status
                                        : '';
                                    String username = orderItems.isNotEmpty
                                        ? orderItems[0].username
                                        : '';
                                    double totalPrice =
                                        orderItems[0].totalPrice;

                                    return _buildOrderItemCard(
                                      orderItems,
                                      orderID,
                                      status,
                                      false,
                                      currentUser!.uid,
                                      username,
                                      totalPrice,
                                      databaseService
                                    );
                                  },
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              )
            :

            //if he/she is admin
            Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4.0),
                            MaterialButton(
                              onPressed: _showDatePicker,
                              padding: EdgeInsets.zero,
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      children: [
                        StreamBuilder<List<List<OrderItem>>>(
                            // stream: DatabaseService(uid: currentUser!.uid)
                            stream: DatabaseService(uid: currentUser!.uid)
                                .getSellerOrder(selectedDate: formattedDate),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No order available",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                List<List<OrderItem>> allOrders =
                                    snapshot.data ?? [];

                                // Group order items by order ID
                                Map<String, List<OrderItem>> groupedOrders = {};

                                for (var customerOrders in allOrders) {
                                  for (var orderItem in customerOrders) {
                                    String orderID = orderItem.orderID;

                                    if (!groupedOrders.containsKey(orderID)) {
                                      groupedOrders[orderID] = [];
                                    }

                                    groupedOrders[orderID]!.add(orderItem);
                                  }
                                }

                                return ListView.builder(
                                  itemCount: groupedOrders.length,
                                  itemBuilder: (context, index) {
                                    String orderID =
                                        groupedOrders.keys.elementAt(index);
                                    List<OrderItem> orderItems =
                                        groupedOrders[orderID] ?? [];
                                    String status = orderItems.isNotEmpty
                                        ? orderItems[0].status
                                        : '';
                                    String username = orderItems.isNotEmpty
                                        ? orderItems[0].username
                                        : '';
                                    double totalPrice =
                                        orderItems[0].totalPrice;

                                    return _buildOrderItemCard(
                                      orderItems,
                                      orderID,
                                      status,
                                      true, // Assuming this is an admin view
                                      currentUser!.uid,
                                      username,
                                      totalPrice,
                                      databaseService
                                    );
                                  },
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ));
  }

  Widget _buildOrderItemCard(
    List<OrderItem> orderItems,
    String orderID,
    String status,
    bool isAdmin,
    String currentUserid,
    String username,
    double totalPrice,
      DatabaseService databaseService,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 196, 114, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orderID,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isAdmin)
                  Text(
                    'Username: $username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Order Items
          for (var orderItem in orderItems) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card(
                elevation: 0, // Set to 0 to remove inner card shadow
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          orderItem.foodImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderItem.foodName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Quantity: ${orderItem.quantity}'),
                            Text(
                                'Price: \RM${orderItem.price.toStringAsFixed(2)}'),
                            if (!isAdmin)
                              ElevatedButton(
                                onPressed: () async {
                                  bool orderExists = await databaseService.doesOrderIDExist(orderItem.foodID,orderID);
                                  if (!orderExists) {
                                    _popupReview(orderItem);
                                  }
                                },
                                child: Text('Give Review'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
          // Total Price, Status Dropdown, and Status Text
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 196, 114, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price: \RM${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isAdmin)
                  DropdownButton<String>(
                    value: status ?? 'Preparing',
                    onChanged: (newStatus) async {
                      if (newStatus == 'Complete') {
                        await DatabaseService(uid: currentUserid)
                            .updateOrderStatus(orderID, newStatus!);
                      }

                      setState(() {
                        status = newStatus!;
                      });
                    },
                    items: <String>['Preparing', 'Complete']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                if (!isAdmin)
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
