import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../services/database.dart';
import '../menu/provider/menu_provider/menu_provider.dart';

class reviewForm extends StatefulWidget {

  const reviewForm({Key? key}) : super(key: key);

  @override
  State<reviewForm> createState() => _reviewFormState();
}


class _reviewFormState extends State<reviewForm> {

  final _formKey = GlobalKey<FormState>();
  String review = '';
  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<AppUsers?>(context);

    String? foodID = Provider.of<MenuProvider>(context).foodID ?? "";
    //need to change, foodID need to tally with the food that i clicked

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter review here',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val!.isEmpty ? 'Enter review': null,
            onChanged: (value){
                review = value;
            },
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async{
              await DatabaseService(uid: currentUser!.uid).updateReviewData(foodID, review);
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
