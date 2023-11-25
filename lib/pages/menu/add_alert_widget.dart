import 'package:flutter/material.dart';
import 'package:jood/pages/menu/provider/menu_provider/menu_provider.dart';
import 'package:provider/provider.dart';

import './utils/constants/colors_resources.dart';
import './utils/constants/images.dart';
import 'custom_button.dart';

class AddAlertWidget extends StatefulWidget {
  const AddAlertWidget({super.key});

  @override
  State<AddAlertWidget> createState() => _AddAlertWidgetState();
}

class _AddAlertWidgetState extends State<AddAlertWidget> {
  TextEditingController foodNameCon = TextEditingController();
  TextEditingController priceCon = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AlertDialog(
      scrollable: true,
      backgroundColor: ColorRes.cateBack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: 450,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(height: 30, width: size.width),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Add Item",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                      splashRadius: 0.1,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon:
                          const Icon(Icons.close, color: ColorRes.buttonColor)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Food's Image",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          Images.vegetable,
                          height: 100,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.grey.withOpacity(0.2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            maximumSize: Size(size.width, 20),
                            minimumSize: Size(size.width, 20)),
                        onPressed: () {},
                        child: const Text("Change Image",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black))),
                  ),
                  const SizedBox(height: 10),
                  const Text("Food's Name",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  const SizedBox(height: 5),
                  Container(
                    height: 35,
                    width: size.width,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorRes.grey.withOpacity(0.2)),
                    child: TextFormField(
                        controller: foodNameCon,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 12),
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        cursorColor: ColorRes.grey,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 20),
                  const Text("Food's Price",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  const SizedBox(height: 5),
                  Container(
                    height: 35,
                    width: size.width,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorRes.grey.withOpacity(0.2)),
                    child: TextFormField(
                        controller: priceCon,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 12),
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "RM",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        cursorColor: ColorRes.grey,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomButton(
                      text: "Add",
                       onPressed: () async{
              
                        await Provider.of<MenuProvider>(context, listen: false)
                         .menuCreate(
                          img: Images.vegetable,
                          foodName: foodNameCon.text.trim(),
                          foodPrice: priceCon.text.trim(),
                          context: context
                        );

                        
                        Navigator.pop(context);
                       }
                       ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
