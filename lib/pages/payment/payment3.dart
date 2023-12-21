import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  int currentStep = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepIndicator(currentStep: currentStep),
            SizedBox(height: 10),
            _buildConfirmationSection(),
            Divider(height: 30, thickness: 2),
            _buildPaymentDetails(),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Handle download PDF action
                //_downloadReceipt();
              },
              icon: Icon(Icons.download),
              label: Text('Download Receipt'),
            ),
          ],
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
          SizedBox(height: 10),
          Text(
            'Payment Confirmed',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPaymentDetails() {
    final currentUser = Provider.of<AppUsers?>(context);
    String orderNo = '';
    String dateTime = '';
    String paymentMethod = '';
    String name = '';

    return SingleChildScrollView(
      child: FutureBuilder<Map<String, dynamic>>(
        future: createOrderAndFetchDetails(currentUser, paymentMethod),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> orderDetails = snapshot.data ?? {};

            // Assign orderDetails to your local variables
            orderNo = orderDetails['orderId'] ?? '';
            DateTime orderTimestamp = orderDetails['timestamp']?.toDate() ?? DateTime.now();
            paymentMethod = orderDetails['paymentMethod'] ?? '';
            name = orderDetails['name'] ?? '';

            // Format date and time
            dateTime = DateFormat('dd/MM/yyyy hh:mma').format(orderTimestamp);

            // Return the widget with the updated values
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
  Future<Map<String, dynamic>> createOrderAndFetchDetails(AppUsers? currentUser, String paymentMethod) async {
    try {
      // Create order and get orderId
      String orderId =
      await DatabaseService(uid: currentUser!.uid).createOrder(paymentMethod); //need correction
      print('Order created successfully. OrderId: $orderId');

      // Fetch order details
      Map<String, dynamic> orderDetails =
      await DatabaseService(uid: currentUser.uid).getOrderDetails(orderId);

      print('Order details: $orderDetails');

      // Return order details map
      return orderDetails;
    } catch (e) {
      print("Error creating order or fetching details: $e");
      return {}; // Return an empty map in case of an error
    }
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
  }}
/*
  void _downloadReceipt() {
    // Create a PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Receipt Content Goes Here'),
          );
        },
      ),
    );

    // Save the PDF to a file
    savePDF(pdf);
  }

  Future<void> savePDF(pw.Document pdf) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'receipt.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
 */