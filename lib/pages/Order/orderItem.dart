import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String orderID;
  final String foodName;
  final String foodImage;
  final String foodID;
  int quantity;
  final double price;
  final String orderDate;
  String status;
  final String username;
  final double totalPrice;
  DateTime timeStamp;

  OrderItem({
    required this.orderID,
    required this.foodName,
    required this.foodImage,
    required this.foodID,
    required this.quantity,
    required this.price,
    required this.orderDate,
    required this.status,
    required this.username,
    required this.totalPrice,
    required this.timeStamp,
  });
}
