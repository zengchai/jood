// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/Order/orderItem.dart';
import 'package:jood/pages/order/reviewForm.dart';
import 'package:jood/pages/payment/payment.dart';
import 'package:jood/services/auth.dart';
import 'package:jood/services/database.dart';
import 'package:provider/provider.dart';

//frf
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  late final String review;
  late PageController _pageController;
  int _currentPageIndex = 0;

  void _popupReview(OrderItem orderItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Review'),
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
                      ListTile(
                        leading: Image.asset(
                          orderItem.foodImage,
                          width: 120,
                          height: 120,
                        ),
                        title: Text(orderItem.foodName),
                        subtitle: Text(orderItem.price.toStringAsFixed(2)),
                      ),
                      SizedBox(height: 20),

                      //DO THE STARS THING

                      reviewForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // List<OrderItem> ongoingItems = [
  //   OrderItem(
  //       orderID: '#1234',
  //       foodName: 'Fried Mee',
  //       image: 'assets/friedmee.jpeg',
  //       quantity: 2,
  //       price: 7.0,
  //       status: 'Order Preparing'),
  //   OrderItem(
  //       orderID: '#2345',
  //       foodName: 'Fried Rice',
  //       image: 'assets/friedrice.jpeg',
  //       quantity: 1,
  //       price: 6.0,
  //       status: 'Order Preparing'),
  //   // Add more ongoing items as needed
  // ];

  // List<OrderItem> historyItems = [
  //   OrderItem(
  //       orderID: '#5678',
  //       foodName: 'Fried Rice',
  //       image: 'assets/friedrice.jpeg',
  //       quantity: 1,
  //       price: 6.0,
  //       status: 'Order Delivered'),
  //   // Add more history items as needed
  // ];

  // Date
  late DateTime currentDate = DateTime.now();
  late String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);

    if (currentUser!.uid == 'TnDmXCiJINXWdNBhfZvuAFCuaSL2') {
      showCustomer = false;
    } else {
      showCustomer = true;
    }

    //Date
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    return Scaffold(
        backgroundColor: Colors.white,
        body: showCustomer
            ?
            //if he/she is customer
            Column(
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
                          onPressed: () => _navigateToPage(0),
                          style: TextButton.styleFrom(
                            backgroundColor: _currentPageIndex == 0
                                ? Color.fromARGB(255, 250, 169,
                                    63) // Highlight the selected button
                                : null,
                          ),
                          child: Text('Ongoing'),
                        ),
                        TextButton(
                          onPressed: () => _navigateToPage(1),
                          style: TextButton.styleFrom(
                            backgroundColor: _currentPageIndex == 1
                                ? Color.fromARGB(255, 250, 169,
                                    63) // Highlight the selected button
                                : null,
                          ),
                          child: Text('History'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      children: [
                        //_buildOrderList(false),
                        //_buildOrderList(true),
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
                          onPressed: () => _navigateToPage(0),
                          style: TextButton.styleFrom(
                            backgroundColor: _currentPageIndex == 0
                                ? Color.fromARGB(255, 250, 169,
                                    63) // Highlight the selected button
                                : null,
                          ),
                          child: Text('Incoming'),
                        ),
                        TextButton(
                          onPressed: () => _navigateToPage(1),
                          style: TextButton.styleFrom(
                            backgroundColor: _currentPageIndex == 1
                                ? Color.fromARGB(255, 250, 169,
                                    63) // Highlight the selected button
                                : null,
                          ),
                          child: Text('History'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      children: [
                        StreamBuilder<List<OrderItem>>(
                          // stream: DatabaseService(uid: currentUser!.uid)
                          stream: DatabaseService(uid: currentUser!.uid)
                              .getCustomerOrder(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text("No data available");
                            } else {
                              List<OrderItem> orderData = snapshot.data ?? [];

                              // Display and manipulate cart items in the UI
                              return Column(
                                children: orderData.map((orderItem) {
                                  return _buildOrderItemCard(orderItem, false);
                                }).toList(),
                              );
                            }
                          },
                        ),
                        //_buildOrderList(true),
                      ],
                    ),
                  ),
                ],
              ));
  }

  // Widget _buildOrderList(bool isHistoryPage) {
  //   return StreamBuilder<List<Map<String, dynamic>>>(
  //     stream: DatabaseService(uid: currentUser!.uid).getCustomerOrder(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text("Error: ${snapshot.error}");
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Text("No data available");
  //       } else {
  //         List<Map<String, dynamic>> orderData = snapshot.data ?? [];

  //         return ListView.builder(
  //           itemCount: orderData.length,
  //           itemBuilder: (context, index) {
  //             var data = orderData[index];

  //             // Display the retrieved data
  //             return ListTile(
  //               title: Text(data['foodName']),
  //               subtitle: Text('Price: ${data['foodPrice']}'),
  //               leading: Image.network(data['foodImage']),
  //               // Add other fields as needed
  //             );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _buildOrderItemCard(OrderItem orderItem, bool isHistoryPage) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Color.fromRGBO(248, 232, 209, 1),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: Image.network(
          orderItem.foodImage,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(orderItem.foodName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity: ${orderItem.quantity}'),
                Text('Price: \$${orderItem.price.toStringAsFixed(2)}'),
                if (isHistoryPage) // Conditionally show the review button
                  ElevatedButton(
                    onPressed: () {
                      //_popupReview(orderItem);
                    },
                    child: Text('Give Review'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
