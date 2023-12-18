// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jood/pages/menu/overlay.dart';
import 'package:intl/intl.dart';
import 'package:jood/pages/menu/provider/menu_provider/menu_provider.dart';
import 'package:jood/pages/shoppingcart/CartItem.dart';
import 'package:jood/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import './utils/constants/colors_resources.dart';
import 'add_alert_widget.dart';
import 'custom_button.dart';
import 'edit_aleart_widget.dart';
import 'package:jood/services/database.dart';

class MenuPage extends StatefulWidget {
  //const MenuPage({super.key});

  final List<String> foodReviews;

  const MenuPage({Key? key, required this.foodReviews}) : super(key: key);

  @override
  State<MenuPage> createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<MenuPage> {
  DatabaseService databaseService = DatabaseService(uid: 'your_user_id');
  List<String> foodReviews = [];

  void _popupViewReview(MenuProvider menuProvider, int index) {
    String? foodID = menuProvider.menuList[index].id;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Review'),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CachedNetworkImage(
                            height: 130,
                            width: 90,
                            fit: BoxFit.fill,
                            imageUrl: menuProvider.menuList[index].img ?? '',
                            placeholder: (context, url) {
                              log("Placeholder for image: $url");
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorWidget: (context, url, error) {
                              log("Error loading image: $url, $error");
                              return const Icon(Icons.error);
                            },
                          ),
                          title: Text(menuProvider.menuList[index].title ?? ""),
                          subtitle: Text(
                            menuProvider.menuList[index].price ?? '',
                          ),
                        ),
                        const SizedBox(height: 20),

                        //DO THE STARS THING
                        StreamBuilder<List<ReviewItem>>(
                          stream: databaseService.getReviews(foodID!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<ReviewItem> reviews = snapshot.data ?? [];
                              return Column(
                                children: [
                                  for (ReviewItem reviewItem in reviews)
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        title: Text(reviewItem.reviewContent),
                                        subtitle: Text(
                                          'User: ${reviewItem.userName}, Rating: ${reviewItem.rating}',
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                          },
                        )



                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MenuProvider>(context, listen: false).fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool showCustomer = true;
    final currentUser = Provider.of<AppUsers?>(context);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    if (currentUser!.uid == 'TnDmXCiJINXWdNBhfZvuAFCuaSL2') {
      showCustomer = false;
    } else {
      showCustomer = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorRes.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // await fetchMenuData();
        },
        child: SafeArea(
          child:
              Consumer<MenuProvider>(builder: (context, menuProvider, child) {
            return showCustomer
                ?
                // if he/she is a customer
                Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "MENU",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                            itemCount: menuProvider.menuList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 225),
                            itemBuilder: (ctx, index) {
                              return Container(
                                height: 230,
                                width: size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: ColorRes.cateBorder),
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorRes.cateBack),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () {
                                            _popupViewReview(
                                                menuProvider, index);
                                          },
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: size.width,
                                            fit: BoxFit.fill,
                                            imageUrl: menuProvider
                                                    .menuList[index].img ??
                                                '',
                                            placeholder: (context, url) {
                                              log("Placeholder for image: $url");
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                            errorWidget: (context, url, error) {
                                              log("Error loading image: $url, $error");
                                              return const Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      menuProvider.menuList[index].title ?? "",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        menuProvider.menuList[index].price ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        textAlign: TextAlign.center),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                                text: "Add to cart",
                                                onPressed: () async {
                                                  await DatabaseService(
                                                          uid: currentUser!.uid)
                                                      .addToCart(
                                                          menuProvider
                                                                  .menuList[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          menuProvider
                                                                  .menuList[
                                                                      index]
                                                                  .img ??
                                                              '',
                                                          double.tryParse(menuProvider
                                                                      .menuList[
                                                                          index]
                                                                      .price ??
                                                                  '') ??
                                                              0.0);
                                                }),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  )
                :

                // if he/she is an admin
                Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "EDIT MENU",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                            itemCount: menuProvider.menuList.length + 1,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 225),
                            itemBuilder: (ctx, index) {
                              if (index < menuProvider.menuList.length) {
                                return Container(
                                  height: 230,
                                  width: size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: ColorRes.cateBorder),
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorRes.cateBack),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: InkWell(
                                            onTap: () {
                                              _popupViewReview(
                                                  menuProvider, index);
                                            },
                                            child: CachedNetworkImage(
                                              height: 100,
                                              width: size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: menuProvider
                                                      .menuList[index].img ??
                                                  '',
                                              placeholder: (context, url) {
                                                log("Placeholder for image: $url");
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                              errorWidget:
                                                  (context, url, error) {
                                                log("Error loading image: $url, $error");
                                                return const Icon(Icons.error);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        menuProvider.menuList[index].title ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                          menuProvider.menuList[index].price ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          textAlign: TextAlign.center),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
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
                                                              cateMenu: menuProvider
                                                                      .menuList[
                                                                  index]);
                                                        });
                                                  }),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: CustomButton(
                                                  text: "Delete",
                                                  onPressed: () async {
                                                    context.showOverlayLoader(
                                                        loadingWidget:
                                                            const OverlayLoadingIndicator(),
                                                        asyncFunction:
                                                            () async {
                                                          await Provider.of<
                                                                      MenuProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .menuDelete(
                                                                  id: menuProvider
                                                                      .menuList[
                                                                          index]
                                                                      .id);
                                                        });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    //
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AddAlertWidget();
                                        });
                                  },
                                  child: Container(
                                      height: 210,
                                      width: size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: ColorRes.cateBorder),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: ColorRes.cateBack),
                                      child: const Icon(
                                          Icons.add_circle_outline,
                                          size: 60,
                                          color: ColorRes.cateBorder)),
                                );
                              }
                            }),
                      )
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
