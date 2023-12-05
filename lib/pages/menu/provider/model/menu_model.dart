import 'package:cloud_firestore/cloud_firestore.dart';

import '../menu_provider/menu_provider.dart';

// date conversion (json=>dart)
class MenuModel {
  String? img;
  String? title;
  String? price;

  MenuModel({
    required this.img,
    required this.title,
    required this.price,
  });

  MenuModel.fromJson(Map<String, dynamic> json) {
    img = json['image'];
    title = json['food_name'];
    price = json['food_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = img;
    data['food_name'] = title;
    data['food_price'] = price;

    return data;
  }
}
