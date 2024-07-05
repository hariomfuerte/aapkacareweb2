import 'package:aapkacare/responsive.dart';
import 'package:aapkacare/screens/Profile%20Page/profile_mobile.dart';
import 'package:aapkacare/screens/Profile%20Page/profile_web.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String specification;
  final String city;
  final String name;
  final String image;
  const Profile({super.key, required this.specification, required this.city, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
            mobile: ProfileMobile(
              city: city,
              name: name,
              experience: specification,
              image:image,
            ),
            tablet: DoctorWeb(
              city: city,
              name: name,
              specification: specification,
              image:image,
            ),
            desktop: DoctorWeb(
              image:image,
              city: city,
              name: name,
              specification: specification,
            )));
  }
}
