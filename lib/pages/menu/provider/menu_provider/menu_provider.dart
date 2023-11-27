import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jood/pages/menu/provider/model/menu_model.dart';
import '../../utils/constants/colors_resources.dart';
import '../response_wrapper/response_wrapper.dart';


final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference menuCollectionRef = firestore.collection('menu');

class MenuProvider extends ChangeNotifier {
  Future menuCreate({
    String? img,
    String? foodName,
    String? foodPrice,
    BuildContext? context,
  }) async {
    Response response = Response();

    Map<String, dynamic> preams = {};
    preams['image'] = img;
    preams['food_name'] = foodName;
    preams['food_price'] = foodPrice;

    try {
      await menuCollectionRef.add(preams);
      // DocumentReference menuRef = await menuCollectionRef.add(preams);
      // MenuModel menuModel =  MenuModel(img: img!, title: foodName!, price: foodPrice!);

      response.statusCode = 200;
      showSuccessToast('Add Successfully!');
      await fetchMenu();
      notifyListeners();
    } catch (e) {
      response.statusCode = 500;
      showFailedToast('Failed');
      notifyListeners();
    }
  }

  // fetch menu
  List<MenuModel> menuList = [];
  Future fetchMenu() async {
    menuList = [];
    try{
      QuerySnapshot querySnapshot = await menuCollectionRef.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> preams = document.data() as Map<String, dynamic>;
        MenuModel menuModel = MenuModel.fromJson(preams);
        menuList.add(menuModel);
        print('==@ Fetch Data title: ${menuModel.title}');
      }
      notifyListeners();

    } catch(e){
      log(e.toString());
    }
  }
}



///




showSuccessToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorRes.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

showFailedToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorRes.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
