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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildDetailItem('Order No', 'null'),
        _buildDetailItem('Date & Time', 'null'),
        _buildDetailItem('Payment Method', 'null'),
        _buildDetailItem('Name', 'null'),
        _buildDetailItem('Email', 'null'),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

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