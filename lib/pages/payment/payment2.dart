import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/users.dart';
import '../../services/database.dart';

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
          _buildStep(1),
          _buildBridge(),
          _buildStep(2,isFirst: true),
          _buildBridge(),
          _buildStep(3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, {bool isFirst = false}) {
    bool isCurrentStep = currentStep == stepNumber;
    double circleSize = isCurrentStep ? 40.0 : 30.0;

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
      width: 40,
      height: 2,
      color: Colors.grey,
    );
  }
}


class MethodPage extends StatefulWidget {
  @override
  _MethodPageState createState() => _MethodPageState();
}

class _MethodPageState extends State<MethodPage> {
  double totalPrice = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the total price from the arguments
    totalPrice = ModalRoute.of(context)?.settings.arguments as double? ?? 0.0;
  }
  int currentStep = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF00000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepIndicator(currentStep: currentStep),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
              ),
            ),
            SizedBox(height: 20),
            PaymentOptionCard(
              optionName: 'TouchNGo',
              imagePath: 'assets/TnG.png',
            ),
            PaymentOptionCard(
              optionName: 'Cash On Delivery',
              imagePath: 'assets/CoD.png',
            ),
            SizedBox(height: 20), // Add some space between payment options and total price

          ],
        ),
      ),
    );
  }
}
class PaymentOptionCard extends StatelessWidget {
  final String optionName;
  final String imagePath;

  PaymentOptionCard({required this.optionName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          optionName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: EdgeInsets.all(8.0),
        leading: Container(
          width: 80.0,
          height: 80.0,
          child: Image.asset(
            imagePath,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF0000), // Same background color as the "Pay" button
            onPrimary: Colors.black, // Same text color as the "Pay" button
          ),
          onPressed: () async {
            String selectedPaymentMethod = optionName;

            try {
              String orderId = await DatabaseService(uid: Provider.of<AppUsers?>(context, listen: false)!.uid)
                  .createOrder(selectedPaymentMethod);

              await DatabaseService(uid: Provider.of<AppUsers?>(context, listen: false)!.uid).clearCart();

              Navigator.pushNamed(context, '/receipt', arguments: orderId);
            } catch (e) {
              // Handle error
            }
          },
          child: Text('Select'),
        ),
      ),
    );
  }
}