// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class AppContext{
  BuildContext context;
  AppContext(this.context);
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}