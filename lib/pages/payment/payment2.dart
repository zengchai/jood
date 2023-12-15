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


class MethodPage extends StatefulWidget {
  @override
  _MethodPageState createState() => _MethodPageState();
}

class _MethodPageState extends State<MethodPage> {
  int currentStep = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepIndicator(currentStep: currentStep),
            SizedBox(height: 30),
            Text(
              'Choose Payment Option',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        title: Text(optionName),
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
          onPressed: () async {
            String selectedPaymentMethod = optionName;
            await DatabaseService(uid: Provider.of<AppUsers?>(context, listen: false)!.uid)
                .createOrder(selectedPaymentMethod);
            await Navigator.pushNamed(context, '/receipt');
          },
          child: Text('Select'),
        ),
        onTap: () {
          // Optionally handle the selection when tapping the entire card
          // This can be removed if you only want the button to trigger selection
        },
      ),
    );
  }
}
