
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_badge_avatar/circular_badge_avatar.dart';
import 'package:circular_badge_avatar/helper/bottomsheet_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jood/pages/menu/overlay.dart';
import 'package:provider/provider.dart';
import './utils/constants/colors_resources.dart';
import 'custom_button.dart';
import 'provider/menu_provider/menu_provider.dart';
import 'provider/model/menu_model.dart';

class EditAlertWidget extends StatefulWidget {
  final MenuModel? cateMenu;
  const EditAlertWidget({super.key, required this.cateMenu});

  @override
  State<EditAlertWidget> createState() => _EditAlertWidgetState();
}

class _EditAlertWidgetState extends State<EditAlertWidget> {

  TextEditingController? foodNameCon;
  TextEditingController? priceCon;
  XFile? imageSource1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodNameCon = TextEditingController(text: widget.cateMenu?.title);
    priceCon = TextEditingController(text: widget.cateMenu?.price);
  }

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
                    child: Text("Edit Item",
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
                      Flexible(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.grey)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: imageSource1 == null ? CachedNetworkImage(
                              height: 100,
                              width: size.width,
                              fit: BoxFit.fill,
                              imageUrl: widget.cateMenu?.img ?? '',
                              placeholder: (context, url) {
                                log("Placeholder for image: $url");
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorWidget: (context, url, error) {
                                log("Error loading image: $url, $error");
                                return const Icon(Icons.error);
                              },
                            ) : CircularBadgeAvatar(
                              needImagePickerIcon: false,
                              circleBorderRadius: 20,
                              networkImage: widget.cateMenu?.img ?? '',
                              imagePath: imageSource1, // imagePath only accept XFile
                            ),
                          ),
                          // child: CircularBadgeAvatar(
                          //   needImagePickerIcon: false,
                          //   circleBorderRadius: 20,
                          //   networkImage: widget.cateMenu?.img ?? '',
                          //   // imageString: widget.cateMenu?.img ?? '',
                          //   imagePath: imageSource1, // imagePath only accept XFile
                          // ),
                          // child: CircularBadgeAvatar(
                          //   needImagePickerIcon: false,
                          //   circleBorderRadius: 20,
                          //   imageString: cateMenu?.img ?? '' // imagePath only accept XFile
                          // ),
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
                        onPressed: () async {
                          final file =  await showModalBottomSheet<XFile?>(
                              context: context,
                              builder: (context) {
                                return const BottomSheetImagePicker();
                              });

                          setState(() {
                            imageSource1 = file;
                          });
                        },

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
                        text: "Update",
                        onPressed: () async{
                          await context.showOverlayLoader(
                              loadingWidget: const OverlayLoadingIndicator(),
                              asyncFunction: () async{
                                await Provider.of<MenuProvider>(context, listen: false).menuUpdate(
                                  id: widget.cateMenu?.id,
                                  img: imageSource1,
                                  foodName: foodNameCon!.text.trim(),
                                  foodPrice: priceCon!.text.trim(),
                                );
                              }
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
