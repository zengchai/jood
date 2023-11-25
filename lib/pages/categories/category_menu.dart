import 'package:flutter/material.dart';
import 'custom_button.dart';
import './utils/constants/colors_resources.dart';

import './utils/constants/images.dart';
import 'add_alert_widget.dart';
import 'edit_aleart_widget.dart';

class CategoryMenuScreen extends StatefulWidget {
  const CategoryMenuScreen({super.key});

  @override
  State<CategoryMenuScreen> createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenuScreen> {
  List<CateMenu> cateItem = [
    CateMenu(img: Images.vegetable, title: "Vegetable", price: "5.00"),
    CateMenu(img: Images.chinese, title: "Chinese Fried Rice", price: "8.00"),
    CateMenu(img: Images.curry, title: "Curry Rice", price: "9.00"),
    CateMenu(img: Images.chineseRice, title: "Chinese Rice", price: "9.00"),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorRes.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("EDIT MENU",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Row(
                    children: [
                      Icon(Icons.date_range_outlined),
                      Text("19/11/2023",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                  itemCount: cateItem.length + 1,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 225),
                  itemBuilder: (ctx, index) {
                    if (index < cateItem.length) {
                      return Container(
                        height: 230,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: ColorRes.cateBorder),
                            borderRadius: BorderRadius.circular(20),
                            color: ColorRes.cateBack),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  cateItem[index].img,
                                  height: 100,
                                  width: size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              cateItem[index].title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(cateItem[index].price,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                textAlign: TextAlign.center),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                        text: "Edit",
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return EditAlertWidget(
                                                    cateMenu: cateItem[index]);
                                              });
                                        }),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: CustomButton(
                                        text: "Delete", onPressed: () {}),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AddAlertWidget();
                              });
                        },
                        child: Container(
                            height: 210,
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: ColorRes.cateBorder),
                                borderRadius: BorderRadius.circular(20),
                                color: ColorRes.cateBack),
                            child: const Icon(Icons.add_circle_outline,
                                size: 60, color: ColorRes.cateBorder)),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CateMenu {
  String img;
  String title;
  String price;

  CateMenu({required this.img, required this.title, required this.price});
}
