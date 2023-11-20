import 'package:flutter/material.dart';
import 'package:jood/services/auth.dart';

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

class FoodItem {
  final String name;
  final String image;
  int quantity;
  final double price;

  FoodItem({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });
}

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int currentStep = 1;
  final AuthService _auth = AuthService();
  int _selectedIndex = 2;

  //replace with real data
  List<FoodItem> foodItems = [
    FoodItem(name: 'FriedMee', image: 'assets/friedmee.jpeg', quantity: 2, price: 7.0),
    FoodItem(name: 'FriedRice', image: 'assets/friedrice.jpeg', quantity: 1, price: 6.0),
  ];

  double calculateTotalPrice() {
    return foodItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF7b5916).withOpacity(0.75),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return _buildFoodItemCard(foodItems[index]);
                },
              ),
            ),
            SizedBox(height: 16),
            _buildTotalPrice(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to another page for payment
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentConfirmationPage()),
                );
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

  Widget _buildFoodItemCard(FoodItem foodItem) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(
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
    double totalPrice = calculateTotalPrice();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Price:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$$totalPrice',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  void _incrementQuantity(FoodItem foodItem) {
    setState(() {
      foodItem.quantity++;
    });
  }

  void _decrementQuantity(FoodItem foodItem) {
    setState(() {
      if (foodItem.quantity > 0) {
        foodItem.quantity--;
      }
    });
  }
}

class PaymentConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Confirmation'),
      ),
      body: Center(
        child: Text('Payment successful!'),
      ),
    );
  }
}