import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String foodName;
  final String foodImage;
  int quantity;
  final double price;
  final String orderDate;

  OrderItem({
    required this.foodName,
    required this.foodImage,
    required this.quantity,
    required this.price,
    required this.orderDate,
  });
}
