import 'package:aapkacare/responsive.dart';
import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/screens/Hospital/hospital_mobile.dart';
import 'package:aapkacare/screens/Hospital/hospital_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:url_launcher/url_launcher.dart';

class Hospital extends StatefulWidget {
  final String id;
  final String profession;

  const Hospital({super.key, required this.id, required this.profession});

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  List<Map<String, dynamic>> Details = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      String queryTokens = widget.id;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection(widget.profession).where('id', isEqualTo: queryTokens).get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> dataMap = doc.data();

        // Fetching the fields and providing default values if they are null
        String fetchedImage = dataMap['image'] ?? 'assets/d3.png';
        String fetchedName = dataMap['name'] ?? 'name';
        String fetchedMobile = dataMap['mobile'] ?? 'phone';
        String fetchedAddress = dataMap['address'] ?? 'address';
        String fetchedExperience = dataMap['experience'] ?? 'experience';
        String fetched = dataMap['department'] ?? 'department';

        // Creating a map for the new job data
        Map<String, dynamic> newJobData = {
          "name": fetchedName,
          "mobile": fetchedMobile,
          "address": fetchedAddress,
          "image": fetchedImage,
          "experience": fetchedExperience,
          "department": fetched,
        };

        // Updating the state to reflect the new data
        setState(() {
          Details.add(newJobData);
          isLoading = false;
        });
        print("Job data added: $newJobData");
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
    }
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
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 27, 181, 253),
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          title: GestureDetector(
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Responsive(
              mobile: HospitalMobile(
                Details: Details,
              ),
              tablet: HospitalMobile(
                Details: Details,
              ),
              desktop: HospitalWeb(
                Details: Details,
              ),
            ),
    );
  }
}
