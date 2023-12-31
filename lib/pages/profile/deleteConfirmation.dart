import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/userprofile.dart';
import '../../models/users.dart';
import '../../services/database.dart';

class deleteConfirmation extends StatefulWidget {
  const deleteConfirmation({Key? key}) : super(key: key);

  @override
  State<deleteConfirmation> createState() => _addressFormState();
}

class _addressFormState extends State<deleteConfirmation> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAddressController();
  }

  Future<void> _initializeAddressController() async {
    final currentUser = Provider.of<AppUsers?>(context, listen: false);
    final userProfile = await DatabaseService(uid: currentUser!.uid).getUserProfile(currentUser.uid);
    setState(() {
      addressController = TextEditingController(text: userProfile?.address ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUsers?>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
                hintText: 'Address', // Add your placeholder text
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0), // Set the border radius here
                    borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.25), width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                    borderSide: BorderSide(color: Color(0xFF3C312B).withOpacity(0.75), width: 2.0)
                )
            ),
            validator: (val) => val!.isEmpty ? 'Enter an address': null,
          ),
          SizedBox(height: 25,),
          ElevatedButton(
            onPressed: () async{
              await DatabaseService(uid: currentUser!.uid).updateAddressData(addressController.text);
              Navigator.pop(context); // Close the dialog after updating
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3C312B).withOpacity(0.75),),
              foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFCC)),
              minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
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
