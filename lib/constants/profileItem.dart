import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String value;
  bool enable;

  ProfileItem(
      {required this.value, required this.controller, required this.enable});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                enable ? Color(0xFF303030) : Color(0xFFE0E0E0), // Border color
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Border radius
        ),
        child: Column(children: [
          SizedBox(
            height: 7,
          ),
          Row(
            children: [
              SizedBox(
                width: 13,
              ),
              Text(
                '$value',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                fillColor: Colors.white,
                filled: true,
                hintText: '$value', // Add your placeholder text
                enabled: enable,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        4.0), // Set the border radius here
                    borderSide: BorderSide(
                        color: Color(0xFF3C312B).withOpacity(0.1), width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set the border radius here
                    borderSide: BorderSide(
                        color: Color(0xFF3C312B).withOpacity(0.75),
                        width: 2.0))),
            validator: (val) => val!.isEmpty ? 'Enter a name' : null,
          ),
          SizedBox(height: 7.0),
        ]));
  }
}
