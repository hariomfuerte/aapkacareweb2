import 'package:aapkacare/responsive.dart';
import 'package:aapkacare/screens/Home%20Page/home_mobile.dart';
import 'package:aapkacare/screens/Home%20Page/home_web.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Responsive(mobile: HomeMobile(), tablet: HomeMobile(), desktop: HomeWeb()));
  }
}
