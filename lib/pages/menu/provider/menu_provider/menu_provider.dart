import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jood/pages/menu/provider/model/menu_model.dart';

import '../../../../services/database.dart';
import '../../utils/constants/colors_resources.dart';
import '../response_wrapper/response_wrapper.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference menuCollectionRef = firestore.collection('menu');
final Reference menuStorageRef = FirebaseStorage.instance.ref('menu/');

class MenuProvider extends ChangeNotifier {

  String? _foodID;
  String? get foodID => _foodID;

  Future menuCreate({
    String? id,
    XFile? img,
    String? foodName,
    String? foodPrice,
    BuildContext? context,
  }) async {
    Response response = Response();

    try {
      var imgFile = File(img!.path);
      var stgRef = menuStorageRef.child('$img.jpg');

      /// Upload image to Firebase Storage
      await stgRef.putFile(imgFile);

      /// Get the download URL after the upload is complete
      TaskSnapshot taskSnapshot = await stgRef.putFile(imgFile);
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      log('Image Download Url is: $imgUrl');

      //String foodID = menuCollectionRef.doc().id;

      Map<String, dynamic> preams = {};
      if (id != null) {
        preams['id'] = id;
      } else {
        preams['id'] = menuCollectionRef.doc().id;
      }
      preams['image'] = imgUrl;
      preams['food_name'] = foodName;
      preams['food_price'] = foodPrice;

      // DocumentReference menuRef = await menuCollectionRef.add(preams);

      await menuCollectionRef.doc(preams['id']).set(preams);

      String foodID = preams['id'];
      _foodID = foodID;

      log('==@ Preams: $preams');

      response.statusCode == 200;
      showSuccessToast('Add Successfully!');

      DatabaseService databaseService = DatabaseService(uid: 'currentUserId');

      await databaseService.setReviewData(foodID);

      await fetchMenu();
      notifyListeners();
    } catch (e) {
      response.statusCode == 500;
      showFailedToast('Failed');
      notifyListeners();
    }
  }

  //! ==================== |> Edit / Update food <| ====================
  Future menuUpdate({
    String? id,
    XFile? img,
    String? imgPath,
    String? foodName,
    String? foodPrice,
    BuildContext? context,
  }) async {
    Response response = Response();

    try {
      if (img != null) {
        var imgFile = File(img.path);
        var stgRef = menuStorageRef.child('$img.jpg');

        /// Upload image to Firebase Storage
        await stgRef.putFile(imgFile);

        /// Get the download URL after the upload is complete
        TaskSnapshot taskSnapshot = await stgRef.putFile(imgFile);
        String imgUrl = await taskSnapshot.ref.getDownloadURL();
        log('Image Download Url is: $imgUrl');

        //! ========================
        Map<String, dynamic> preams = {};
        if (id != null) {
          preams['id'] = id;
        } else {
          preams['id'] = menuCollectionRef.doc().id;
        }
        preams['image'] = imgUrl;
        preams['food_name'] = foodName;
        preams['food_price'] = foodPrice;
        log('==@ Preams: $preams');

        await menuCollectionRef.doc(id).set(preams);

        response.statusCode == 200;
        showSuccessToast('Update Successfully!');
        await fetchMenu();
        notifyListeners();
      } else {
        //! ========================
        Map<String, dynamic> preams = {};
        if (id != null) {
          preams['id'] = id;
        } else {
          preams['id'] = menuCollectionRef.doc().id;
        }
        preams['image'] = imgPath;
        preams['food_name'] = foodName;
        preams['food_price'] = foodPrice;
        log('==@ Preams: $preams');

        await menuCollectionRef.doc(id).set(preams);

        response.statusCode == 200;
        showSuccessToast('Update Successfully!');
        await fetchMenu();
        notifyListeners();
      }
    } catch (e) {
      response.statusCode == 500;
      showFailedToast('Failed');
      notifyListeners();
    }
  }

  /*
  Future menuUpdate({
    String? id,
    XFile? img,
    String? foodName,
    String? foodPrice,
    BuildContext? context,
  }) async {
    Response response = Response();

    try {
      var imgFile = File(img!.path);
      var stgRef = menuStorageRef.child('$img.jpg');

      /// Upload image to Firebase Storage
      await stgRef.putFile(imgFile);

      /// Get the download URL after the upload is complete
      TaskSnapshot taskSnapshot = await stgRef.putFile(imgFile);
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      log('Image Download Url is ===> @: $imgUrl');

      Map<String, dynamic> preams = {};
      if (id != null) {
        preams['id'] = id;
      } else {
        preams['id'] = menuCollectionRef.doc().id;
      }
      preams['image'] = imgUrl;
      preams['food_name'] = foodName;
      preams['food_price'] = foodPrice;
      log('==@ Preams: $preams');

      await menuCollectionRef.doc(id).set(preams);

      response.statusCode == 200;
      showSuccessToast('Update Successfully!');
      await fetchMenu();
      notifyListeners();
    } catch (e) {
      response.statusCode == 500;
      showFailedToast('Failed');
      notifyListeners();
    }
  } */

  Future menuDelete({
    String? id,
  }) async {
    Response response = Response();
    try {
      // Check if id is not null before proceeding
      if (id != null) {
        // Retrieve the foodID associated with the menu item
        DocumentSnapshot<Map<String, dynamic>> menuSnapshot =
        await menuCollectionRef.doc(id).get() as DocumentSnapshot<Map<String, dynamic>>;

        String? foodID = menuSnapshot.data()?['id'];

        // Check if foodID is not null before proceeding
        if (foodID != null) {
          // Delete the entire document in 'reviews' collection associated with the foodID
          await FirebaseFirestore.instance.collection('reviews').doc(foodID).delete();

          // Delete the documents in 'RfoodRatings' subcollection
          await FirebaseFirestore.instance
              .collection('reviews')
              .doc(foodID)
              .collection('RfoodRatings')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
              doc.reference.delete();
            }
          });

          // Delete the menu item
          await menuCollectionRef.doc(id).delete();
        }
      }

      response.statusCode == 200;
      showSuccessToast('Delete Successfully!');
      await fetchMenu();
      notifyListeners();
    } catch (e) {
      response.statusCode == 500;
      showFailedToast('Failed');
      notifyListeners();
    }
  }


  // fetch menu
  List<MenuModel> menuList = [];
  Future fetchMenu() async {
    try {
      QuerySnapshot querySnapshot = await menuCollectionRef.get();

      /// Clear the existing menuList before adding new items
      menuList.clear();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> preams = document.data() as Map<String, dynamic>;
        MenuModel menuModel = MenuModel.fromJson(preams);
        menuList.add(menuModel);
        log('==@ Fetch Data title: ${menuModel.title}');
        log('==@ Fetch Data Image: ${menuModel.img}');
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}

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