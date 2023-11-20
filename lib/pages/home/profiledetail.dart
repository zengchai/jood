import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/userprofile.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfile>(context);
      print(profile.name);
      print(profile.email);
      print(profile.matricnum);
      print(profile.phonenum);
    return Container();
  }
}
