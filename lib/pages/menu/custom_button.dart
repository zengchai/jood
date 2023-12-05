import 'package:flutter/material.dart';

import './utils/constants/colors_resources.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorRes.buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
    
          maximumSize: Size(size.width, 30),
          minimumSize: Size(size.width, 30)),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
