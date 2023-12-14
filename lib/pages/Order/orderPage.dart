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
import 'package:table_calendar/table_calendar.dart';

//frf
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
        selectedDate =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });

// Update formattedDate
      formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    } else {
      // User canceled the operation
      // You can handle this case as needed, e.g., do nothing or show a message
      print('Date picking canceled');
    }
  }

  // Date
  //DateTime selectedDate = DateTime.now();
  // late Stream<List<OrderItem>> _orderStreamCustomer;
  // late Stream<List<List<OrderItem>>> _orderStreamSeller;

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
                            MaterialButton(
                              onPressed: _showDatePicker,
                              color: Colors.amber,
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
                              color: Colors.amber,
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
                                return Text("No data available");
                              } else {
                                List<List<OrderItem>> allOrders =
                                    snapshot.data ?? [];
                                return ListView.builder(
                                  itemCount: allOrders.length,
                                  itemBuilder: (context, index) {
                                    List<OrderItem> orderItems =
                                        allOrders[index];

                                    // Display and manipulate cart items in the UI
                                    return Column(
                                      children: orderItems.map((orderItem) {
                                        return _buildOrderItemCard(
                                            orderItem, false);
                                      }).toList(),
                                    );
                                  },
                                );
                              }
                            }),
                        //_buildOrderList(true),
                      ],
                    ),
                  ),
                ],
              ));
  }

  Widget _buildOrderItemCard(OrderItem orderItem, bool isHistoryPage) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      width: 400,
      decoration: BoxDecoration(
          color: Color.fromRGBO(248, 232, 209, 1),
          borderRadius: BorderRadius.circular(10)),
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
