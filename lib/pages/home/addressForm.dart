import 'package:flutter/material.dart';

class addressForm extends StatefulWidget {
  const addressForm({Key? key}) : super(key: key);

  @override
  State<addressForm> createState() => _addressFormState();
}

class _addressFormState extends State<addressForm> {

  final _formKey = GlobalKey<FormState>();
  late final String address;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Address',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 10,),
          Divider(
            height: 20, // Adjust the height of the line
            thickness: 1.4, // Adjust the thickness of the line
            color: Colors.black.withOpacity(0.3),
          ),
          SizedBox(height: 35,),
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Address', // Add your placeholder text
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                    borderSide: BorderSide(color: Color(0xFFF6B22D).withOpacity(0.25), width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                    borderSide: BorderSide(color: Color(0xFFF6B22D).withOpacity(0.75), width: 2.0)
                )
            ),
            validator: (val) => val!.isEmpty ? 'Enter an address': null,
            onChanged: (value){
              setState(() {
                address = value;
              });
            },
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () async{
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF6B22D).withOpacity(0.75),),
              foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B)),
              minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
            ),
            child: Text(
              'Update',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
