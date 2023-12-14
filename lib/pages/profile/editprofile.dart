import 'package:flutter/material.dart';
import 'package:jood/constants/profileItem.dart';
import 'package:jood/services/database.dart';
import 'package:jood/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../constants/warningalert.dart';
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
  bool editEnable = false;

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    void _showPanel2(String title, String subtitle) {
      showDialog(
        context: context,
        builder: (context) {
          return WarningAlert(title: title,subtitle: subtitle,);
        },
      );
    };
    void _showPanel(){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Updated successfully'),
            titlePadding: EdgeInsets.fromLTRB(68, 30, 68, 0),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color you want for the back button
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true, // Center the title
        actions: [
          editEnable? TextButton.icon(
            onPressed: () async {
              setState(() {
                editEnable = !editEnable;
              });
            },
            icon: Transform.rotate(
              angle: editEnable ? 45 * (3.14159265358979323846264338327950288 / 180) : 0,
              child: Icon(
                Icons.add,
                size: 30,
                color: Color(0xFF3C312B).withOpacity(0.75),
              ),
            ),
            label: Text(''),
          ):

          TextButton.icon(
              onPressed: () async {
                setState(() {
                  editEnable = !editEnable;
                });
              },
              icon: Icon(Icons.edit,
                size: 25,
                color: Color(0xFF3C312B).withOpacity(0.75),
              ),
              label: Text('')),
        ],
      ),
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
              children: [
                Container(
                padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    ProfileItem(value: 'Name', controller: nameController, enable: editEnable),
                    SizedBox(height: 30,),
                    ProfileItem(value: 'Email', controller: emailController, enable: false),
                    SizedBox(height: 30,),
                    ProfileItem(value: 'Matric Number', controller: matricController, enable: editEnable),
                    SizedBox(height: 30,),
                    ProfileItem(value: 'Phone Number', controller: phonenumController, enable: editEnable),
                    SizedBox(height: 30,),
                    ProfileItem(value: 'Address', controller: addressController, enable: editEnable),
                    SizedBox(height:40.0),
                    editEnable ? ElevatedButton(
                          onPressed: () async{
                            if(nameController.text.isEmpty||matricController.text.isEmpty||phonenumController.text.isEmpty||addressController.text.isEmpty){
                              _showPanel2("Error","Some field is empty. Please check the field an make sure all the details are filled in.");
                            }
                            else if(matricController.text.length <= 8){
                              _showPanel2("Error","The format of your matric number might be wrong. It should looks something like A23EC2311.");
                            }
                            else{
                            await DatabaseService(uid: user!.uid).updateUserData(nameController.text , emailController.text ,matricController.text ,phonenumController.text ,addressController.text);
                            setState(() {
                              editEnable = false;
                            });
                            _showPanel();} // Close the dialog after updating
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
                        ): Container()
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
