import 'dart:math';

import 'package:aapkacare/responsive.dart';
import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/screens/Result%20Page/result_mobile.dart';
import 'package:aapkacare/screens/Result%20Page/result_web.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:aapkacare/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Result extends StatefulWidget {
  final String experience;
  final String location;

  const Result({super.key, required this.experience, required this.location});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List<Map<String, dynamic>> ResultDataList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      String normalizedQuery = widget.location.toLowerCase();
      List<String> queryTokens = normalizedQuery.split(',').map((s) => s.trim()).toList();
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection(widget.experience).get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> dataMap = doc.data();

        String address = dataMap['address'] ?? '';

        List<String> addressTokens = address.toLowerCase().split(',').map((s) => s.trim()).toList();

        bool matches = queryTokens.any((queryToken) => addressTokens.contains(queryToken));
        if (matches) {
          String fetchedImage = dataMap['image'] ?? 'assets/d3.png';
          String fetchedName = dataMap['name'] ?? 'name';
          String fetchedPhone = dataMap['mobile'] ?? 'phone';
          String fetchedAddress = address; // Use the original address
          String fetchedExperience = dataMap['experience'] ?? 'experience';
          String fetchedId = dataMap['id'] ?? 'id';

          Map<String, dynamic> newJobData = {
            "id": fetchedId,
            "name": fetchedName,
            "phone": fetchedPhone,
            "address": fetchedAddress,
            "image": fetchedImage,
            "experience": fetchedExperience,
            "containerColor": getRandomBrightColor(),
          };

          setState(() {
            ResultDataList.add(newJobData);
          });
          // print("Job data added: $newJobData");
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Color getRandomBrightColor() {
    Random random = Random();
    // Minimum value to avoid dark colors
    int minValue = 128;
    int red = minValue + random.nextInt(256 - minValue);
    int green = minValue + random.nextInt(256 - minValue);
    int blue = minValue + random.nextInt(256 - minValue);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  startLaunchURL(String url) async {
    // const url = 'https://flutter.dev';

    var urllaunchable = await canLaunchUrl(Uri.parse(url)); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); //launch is from url_launcher package to launch URL
    } else {
      print("URL can't be launched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0 * s.customHeight),
        child: s.isDesktop
            ? Center(
                child: const NavBar(),
              )
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 27, 181, 253),
                scrolledUnderElevation: 0,
                title:GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          ImagePath.adsLogo,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30, top: 7),
                      child: Container(
                        width: 100,
                        child: Image.asset(
                          'assets/images/google_play.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: Responsive(
        mobile: ResultMobile(
          experience: widget.experience,
          location: widget.location,
          Result: ResultDataList,
        ),
        tablet: ResultMobile(
          experience: widget.experience,
          location: widget.location,
          Result: ResultDataList,
        ),
        desktop: ResultWeb(
          experience: widget.experience,
          location: widget.location,
          Result: ResultDataList,
        ),
      ),
    );
  }
}
