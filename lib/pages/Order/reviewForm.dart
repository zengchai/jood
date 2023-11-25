import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../services/database.dart';

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
              //await DatabaseService(uid: users!.uid).updateReviewData('','','review');
              await DatabaseService(uid: currentUser!.uid).updateReviewData('','', review);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
