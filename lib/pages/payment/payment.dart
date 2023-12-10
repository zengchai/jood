import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/pages/shoppingcart/CartItem.dart';
import 'package:jood/services/auth.dart';
import 'package:collection/collection.dart';
import 'package:jood/services/database.dart';

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
        color: isCurrentStep ? Colors.blue : Colors.grey,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            color: Colors.white,
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

// class FoodItem {
//   final String name;
//   final String image;
//   int quantity;
//   final double price;

//   FoodItem({
//     required this.name,
//     required this.image,
//     required this.quantity,
//     required this.price,
//   });
// }

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

  // replace with real data
  // List<FoodItem> foodItems = [
  //   FoodItem(name: 'FriedMee', image: 'assets/friedmee.jpeg', quantity: 2, price: 7.0),
  //   FoodItem(name: 'FriedRice', image: 'assets/friedrice.jpeg', quantity: 1, price: 6.0),
  // ];

  double calculateTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepIndicator(
                currentStep: currentStep), // Add the step indicator
            Text(
              'CART',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: cartItems.length,
            //     itemBuilder: (context, index) {
            //       return _buildFoodItemCard(cartItems[index]);
            //     },
            //   ),
            // ),
            StreamBuilder<List<CartItem>>(
              stream: DatabaseService(uid: '').getCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<CartItem> cartItems = snapshot.data ?? [];
                  // Display and manipulate cart items in the UI
                  return Column(
                    children: cartItems.map((item) {
                      return _buildFoodItemCard(item);
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            _buildTotalPrice(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Navigate to another page for payment
                await Navigator.pushNamed(context, '/method');
              },
              child: Text('Pay'),
            ),
          ],
        ),
      ),

      //bottomNavigationBar=============================
      bottomNavigationBar: Container(
        height: 70.0, //height of bar
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
        leading: Image.network(
          foodItem.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(foodItem.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${foodItem.price}'),
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

  Widget _buildTotalPrice() {
    double totalPrice =
        cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Price:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$$totalPrice',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  // void _incrementQuantity(CartItem foodItem) {
  //   setState(() {
  //     foodItem.quantity++;
  //   });
  // }

  // void _decrementQuantity(CartItem foodItem) {
  //   setState(() {
  //     if (foodItem.quantity > 0) {
  //       foodItem.quantity--;
  //     }
  //   });
  // }

  void _incrementQuantity(CartItem cartItem) {
  setState(() {
    cartItem.quantity++;
    // Update quantity in Firestore
    DatabaseService(uid: '').updateCartItem(cartItem);
  });
}

void _decrementQuantity(CartItem cartItem) {
  setState(() {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      // Update quantity in Firestore
      DatabaseService(uid: '').updateCartItem(cartItem);
    } else {
      // If quantity is 1, remove the item from the cart
      _removeCartItem(cartItem);
    }
  });
}

void _removeCartItem(CartItem cartItem) {
  setState(() {
    // Remove the item from the cart locally
    cartItems.remove(cartItem);
    // Remove the item from Firestore
    DatabaseService(uid: '').removeCartItem(cartItem);
  });
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
