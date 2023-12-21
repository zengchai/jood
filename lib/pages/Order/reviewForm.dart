import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../services/database.dart';
import '../menu/provider/menu_provider/menu_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ReviewForm extends StatefulWidget {
  final String foodID;

  const ReviewForm({Key? key, required this.foodID}) : super(key: key);

  @override
  State<ReviewForm> createState() => _reviewFormState();
}


class _reviewFormState extends State<ReviewForm> {

  final _formKey = GlobalKey<FormState>();
  String review = '';
  double rating = 0;

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<AppUsers?>(context);

    //String? foodID = Provider.of<MenuProvider>(context).foodID ?? "";
    String foodID = widget.foodID;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
          ),

          SizedBox(height: 10),

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
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async{
              await DatabaseService(uid: currentUser!.uid).updateReviewData(foodID, review, rating);
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
