import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jood/constants/warningalert.dart';
import 'package:jood/models/users.dart';
import 'package:jood/pages/Order/orderPage.dart'; //yam
import 'package:jood/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebaseuser
  AppUsers? _userFromFirebaseUser(User user) {
    return user != null ? AppUsers(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUsers> get changeuser {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!)!);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? users = result.user;

      return _userFromFirebaseUser(users!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? users = result.user;
      return _userFromFirebaseUser(users!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? users = result.user;

      //create a new document for the new user with the uid
      await DatabaseService(uid: users!.uid)
          .setUserData(users.uid, name, email, '', '', '');
      await DatabaseService(uid: users!.uid).setPaymentData('TnG', '0.00');
      await DatabaseService(uid: users!.uid).updateReviewData('');
      return _userFromFirebaseUser(users);
    } catch (e) {
      if (e is FirebaseAuthException) {
        showDialog(
          context: context, // Make sure to have access to the current context
          builder: (BuildContext context) {
            return WarningAlert(title: 'Error', subtitle: '${e.message}');
          },
        );
      }
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showDialog(
          context: context, // Make sure to have access to the current context
          builder: (BuildContext context) {
            return WarningAlert(title: 'Error', subtitle: '${e.message}');
          },
        );
      }
    }
  }

  // Future ongoingOrder(List<OrderItem> orderItem) async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       // Update user data in the database
  //       await DatabaseService(uid: user.uid).updateOngoingOrder(orderItem);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future orderHistory(List<OrderItem> orderItem) async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       // Update user data in the database
  //       await DatabaseService(uid: user.uid).updateOrderHistory(orderItem);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // sign out
  Future signOut(BuildContext context) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (e is FirebaseAuthException) {
        showDialog(
          context: context, // Make sure to have access to the current context
          builder: (BuildContext context) {
            return WarningAlert(title: 'Error',subtitle: '${e.message}');
          },
        );
      }
    }
  }

  Future<void> deleteUserData(String uid) async {
    final firestore = FirebaseFirestore.instance;

    // Define a list of collection names associated with the user
    List<String> collectionNames = ['user', 'payments'];

    // Iterate through the collections and delete documents by UID
    for (String collectionName in collectionNames) {
      await firestore.collection(collectionName).doc(uid).delete();
    }
  }

  Future deleteUserAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await deleteUserData(user.uid); // Delete Firestore data first
        await user.delete(); // Delete the Authentication account
        showDialog(
          context: context, // Make sure to have access to the current context
          builder: (BuildContext context) {
            return WarningAlert(title: 'Deleted',subtitle: 'The account has been deleted',);
          },
        );
        return await FirebaseAuth.instance.signOut();
      } catch (e) {
        showDialog(
          context: context, // Make sure to have access to the current context
          builder: (BuildContext context) {
            return WarningAlert(title: 'Error', subtitle: e.toString(),);
          },
        );
        print("Error deleting user account: $e");
      }
    }
  }
}
