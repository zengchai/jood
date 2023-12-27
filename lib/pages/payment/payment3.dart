import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/users.dart';
import '../../services/database.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
          _buildStep(2),
          _buildBridge(),
          _buildStep(3, isFirst: true),
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

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  int currentStep = 3;

  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context)!.settings.arguments as String;


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF00000),
          automaticallyImplyLeading: false,
          title: Text('Receipt'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
        backgroundColor: Colors.brown[50],
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: RepaintBoundary(
            key: GlobalKey(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomStepIndicator(currentStep: currentStep),
                SizedBox(height: 10),
                _buildConfirmationSection(),
                Divider(height: 30, thickness: 2),
                _buildPaymentDetails(orderId),
                SizedBox(height: 30),

              ],
            ),
          ),
        ),
      );
  }

  Widget _buildConfirmationSection() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60.0,
          ),
          SizedBox(height: 15 ), // Add more space below the icon
          Text(
            'Payment Confirmed',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15), // Add more space below the icon
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(String orderId) {
    final currentUser = Provider.of<AppUsers?>(context);
    String orderNo = '';
    String dateTime = '';
    String paymentMethod = '';
    String name = '';

    return SingleChildScrollView(
      child: FutureBuilder<Map<String, dynamic>>(
        future: DatabaseService(uid: currentUser!.uid).getOrderDetails(orderId), builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> orderDetails = snapshot.data ?? {};

            // Assign orderDetails to local variables
            orderNo = orderDetails['orderId'] ?? '';
            DateTime orderTimestamp = orderDetails['timestamp']?.toDate() ?? DateTime.now();
            paymentMethod = orderDetails['paymentMethod'] ?? '';
            name = orderDetails['name'] ?? '';

            dateTime = DateFormat('dd/MM/yyyy hh:mma').format(orderTimestamp);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                _buildDetailItem('Order No', orderNo),
                _buildDetailItem('Date & Time', dateTime),
                _buildDetailItem('Payment Method', paymentMethod),
                _buildDetailItem('Name', name),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
