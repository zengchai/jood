import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/pages/shoppingcart/CartItem.dart';
import 'package:jood/services/auth.dart';
import 'package:collection/collection.dart';
import 'package:jood/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentStep;

  CustomStepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(1, isFirst: true),
          _buildBridge(),
          _buildStep(2),
          _buildBridge(),
          _buildStep(3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, {bool isFirst = false}) {
    bool isCurrentStep = currentStep == stepNumber;
    double circleSize = isCurrentStep ? 30.0 : 20.0;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentStep ? Colors.white : Colors.grey,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBridge() {
    return Container(
      width: 30,
      height: 2,
      color: Colors.grey,
    );
  }
}

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}
class _PaymentState extends State<Payment> {
  int currentStep = 1;
  final AuthService _auth = AuthService();
  int _selectedIndex = 2;

  // Updated: Maintain a list of selected food items in the cart
  List<CartItem> cartItems = [];

  @override

  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUsers?>(context);
    if (currentUser == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/authenticate');
      });
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00000),
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('CART', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepIndicator(
              currentStep: currentStep,
            ),
            SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: StreamBuilder<List<CartItem>>(
                    stream: DatabaseService(uid: currentUser!.uid).getCartItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<CartItem> cartItems = snapshot.data ?? [];
                        return Column(
                          children: cartItems.map((item) {
                            return _buildFoodItemCard(item);
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTotalPrice(), // Display Total Price here
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0000),
                    onPrimary: Colors.black,
                  ),
                  onPressed: () async {
                    // Check if the cart is not empty
                    bool isCartNotEmpty = await DatabaseService(uid: Provider.of<AppUsers?>(context, listen: false)!.uid)
                        .isCartNotEmpty();

                    if (isCartNotEmpty) {
                      Navigator.pushNamed(context, '/method');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('There is nothing in your cart.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar=============================
      bottomNavigationBar: Container(
        height: 30.0, // height of bar
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(CartItem foodItem) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: foodItem.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(foodItem.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: RM${foodItem.price.toStringAsFixed(2)}'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _decrementQuantity(foodItem);
                  },
                ),
                Text('${foodItem.quantity}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _incrementQuantity(foodItem);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _incrementQuantity(CartItem cartItem) {
    final currentUser = Provider.of<AppUsers?>(context, listen: false);
    setState(() {
      cartItem.quantity++;
    });
    // Update quantity in Firestore
    DatabaseService(uid: currentUser!.uid).addCartItem(cartItem);
  }

  void _decrementQuantity(CartItem cartItem) {
    final currentUser = Provider.of<AppUsers?>(context, listen: false);
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
        // Update quantity in Firestore
        DatabaseService(uid: currentUser!.uid).minusCartItem(cartItem);
      } else {
        _removeCartItem(cartItem, currentUser);
      }
    });
  }
  void _removeCartItem(CartItem cartItem, AppUsers? currentUser) {
    setState(() {
      // Remove the item from the cart locally
      cartItems.remove(cartItem);
    });
    // Remove the item from Firestore
    DatabaseService(uid: currentUser!.uid).removeCartItem(cartItem);
  }

  Widget _buildTotalPrice() {
    final currentUser = Provider.of<AppUsers?>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 8), // Add some top margin
      child: StreamBuilder<List<CartItem>>(
        stream: DatabaseService(uid: currentUser!.uid).getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<CartItem> cartItems = snapshot.data ?? [];
            double totalPrice =
            cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

            return Text(
              'Total Price: RM${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          }
        },
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/menu');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/payment');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
