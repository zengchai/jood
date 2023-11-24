import 'package:flutter/material.dart';
import 'package:jood/services/database.dart';
import 'package:jood/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../models/userprofile.dart';
import '../../models/users.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController matricController = TextEditingController();
  TextEditingController phonenumController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showPanel(){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Updated successfully'),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [ Container(
                  padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async{
                      Navigator.pop(context); // Close the dialog after updating
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )],
              ),
            ),
          );
        },
      );
    };

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<UserProfile?>(
        // Use FutureBuilder to wait for the Future<UserProfile> to complete
        future: DatabaseService(uid: Provider.of<AppUsers?>(context)!.uid)
            .getUserProfile(Provider.of<AppUsers?>(context)!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while waiting for the Future to complete
            return Loading();
          } else if (snapshot.hasError) {
            // Handle errors if the Future completes with an error
            return Text('Error: ${snapshot.error}');
          } else {
            // Use the UserProfile once the Future is complete
            UserProfile user = snapshot.data!;
            nameController.text = '${user.name}';
            emailController.text = '${user.email}';
            matricController.text = '${user.matricnum}';
            phonenumController.text = '${user.phonenum}';
            addressController.text = '${user.address}';
            return ListView(
              children: [Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Name', // Add your placeholder text
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a name': null,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email', // Add your placeholder text
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a email': null,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: matricController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Matric Number', // Add your placeholder text
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a matric number': null,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: phonenumController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Phone Number', // Add your placeholder text
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a phone number': null,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Address', // Add your placeholder text
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.10), width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an address': null,
                    ),
                    SizedBox(height:50.0),
                    ElevatedButton(
                      onPressed: () async{
                        await DatabaseService(uid: user!.uid).updateUserData(nameController.text , emailController.text ,matricController.text ,phonenumController.text ,addressController.text);
                        _showPanel(); // Close the dialog after updating
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Add more widgets to display other user information
                  ],
                ),
              ),]
            );
          }
        },
      ),
    );
  }
}
