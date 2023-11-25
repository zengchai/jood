import 'package:flutter/material.dart';

import '../../services/database.dart';

class reviewForm extends StatefulWidget {
  const reviewForm({Key? key}) : super(key: key);

  @override
  State<reviewForm> createState() => _reviewFormState();
}

class _reviewFormState extends State<reviewForm> {

  final _formKey = GlobalKey<FormState>();
  late final String review;
  @override
  Widget build(BuildContext context) {
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
              setState(() {
                review = value;
              });
            },
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async{
              //await DatabaseService(uid: users!.uid).updateReviewData('','','review');
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
