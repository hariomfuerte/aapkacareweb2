import 'dart:convert';
import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/screens/Result%20Page/Result.dart';
import 'package:aapkacare/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyDEbV8pJrdpVk5sFC0pGaxXyag4IpRoRTA";

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  String test = '';
  String? _selectedExperience;
  bool _isListViewVisible = false;
  TextEditingController _locationController = TextEditingController();

  List<dynamic> listOfLocation = [];
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onChange);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Doctor').get();
      setState(() {
        _data = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
      // print("$_data");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  _onChange() {
    placeSuggestion(_locationController.text);
  }

  Future<void> placeSuggestion(String input) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$kGoogleApiKey';
    final corsProxy = 'https://api.allorigins.win/raw?url=';

    final finalUrl = corsProxy + Uri.encodeComponent(url);
    try {
      final response = await http.get(Uri.parse(finalUrl), headers: {
        "x-requested-with": "XMLHttpRequest",
      });
      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = json.decode(response.body)['predictions'];
        });
      } else {
        print("Response.........Error ");
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  // String _selectedExperience = '';
  List<String> _experiences = [
    'Doctor',
    'Nurse',
    'Hospital',
    'Patient',
  ];

  startLaunchURL(String url) async {
    // const url = 'https://flutter.dev';

    var urllaunchable = await canLaunchUrl(Uri.parse(url)); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); //launch is from url_launcher package to launch URL
    } else {
      print("URL can't be launched.");
    }
  }

  List<String> sliderImages = [
    'assets/b1.png',
    'assets/b2.png',
    'assets/b3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
  ];

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    // final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xfff4f9fe),
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
                title: Row(
                  children: [
                    GestureDetector(
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
                    SizedBox(
                      width: 20 * s.customWidth,
                    ),
                    Text(
                      s.isMobile ? "" : "AAPKA CARE",
                      style: GoogleFonts.play(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Container(
                        width: 370 * s.customWidth,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            "Download",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 400,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          gradient: LinearGradient(colors: [
                            // Color(0xFF2ecbe9),
                            Color.fromARGB(255, 48, 145, 241),
                            Color.fromARGB(255, 27, 181, 253),
                            Color.fromARGB(255, 246, 246, 246),
                          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Stack(
                          children: [
                            generatePositionedCircle(
                              left: 60,
                              top: 85,
                              radius: 45,
                              imagePath: 'assets/d8.png',
                            ),
                            generatePositionedCircle(
                              left: 190,
                              top: 12,
                              radius: 33,
                              imagePath: 'assets/d4.png',
                            ),
                            generatePositionedCircle(
                              left: 300,
                              top: 70,
                              radius: 65,
                              imagePath: 'assets/d3.png',
                            ),
                            generatePositionedCircle(
                              left: 450,
                              top: 10,
                              radius: 32,
                              imagePath: 'assets/n2.png',
                            ),
                            generatePositionedCircle(
                              left: 580,
                              top: 60,
                              radius: 45,
                              imagePath: 'assets/d3.png',
                            ),
                            generatePositionedCircle(
                              left: 760,
                              top: 100,
                              radius: 50,
                              imagePath: 'assets/d9.png',
                            ),
                            generatePositionedCircle(
                              left: 880,
                              top: 15,
                              radius: 35,
                              imagePath: 'assets/d3.png',
                            ),
                            Positioned(
                              top: 220,
                              left: MediaQuery.of(context).size.width / 4.5,
                              child: Text(
                                "Search For your Doctor",
                                style: GoogleFonts.poppins(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              top: 260,
                              left: MediaQuery.of(context).size.width / 5.6,
                              child: Text(
                                "When you are searching for a Doctor, there are a few things you can do to",
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Positioned(
                              top: 275,
                              left: MediaQuery.of(context).size.width / 3.8,
                              child: Text(
                                "get the most out of your search ",
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ).py20(),

                      // Job Search Bar
                      Positioned(
                        bottom: 0,
                        left: s.width / 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 1.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                    color: Colors.grey.shade400,
                                  )
                                ],
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50.0),
                                  right: Radius.circular(50.0),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Theme(
                                          data: ThemeData(focusColor: Color.fromARGB(255, 53, 189, 252), splashColor: Colors.transparent),
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedExperience,
                                            borderRadius: BorderRadius.circular(10),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedExperience = newValue;
                                              });
                                            },
                                            items: _experiences
                                                .map<DropdownMenuItem<String>>(
                                                  (String value) => DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusColor: Colors.white,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              hintText: 'What you need',
                                              hintStyle: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(left: 40),
                                            style: GoogleFonts.poppins(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        CircleAvatar(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Color.fromARGB(255, 27, 181, 253),
                                          child: Icon(
                                            Icons.search,
                                            size: 20.0,
                                          ),
                                          radius: 19,
                                        ).pSymmetric(v: 8, h: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30 * s.customHeight,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                  ),
                                  Container(
                                      height: 40 * s.customHeight,
                                      width: 270 * s.customWidth,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 3 * s.customHeight, bottom: 8),
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                _isListViewVisible = value.isNotEmpty;
                                              });
                                            },
                                            controller: _locationController,
                                            cursorColor: Colors.black,
                                            showCursor: true,
                                            decoration: InputDecoration.collapsed(
                                              fillColor: Colors.white,
                                              focusColor: Colors.white,
                                              hintText: 'Enter Location',
                                              hintStyle: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            style: GoogleFonts.poppins(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                                  InkWell(
                                    onTap: () {
                                      if (_selectedExperience != null && _locationController.text.isNotEmpty) {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => Result(
                                                  experience: _selectedExperience.toString(),
                                                  location: _locationController.text,
                                                )));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: Duration(milliseconds: 500),
                                            content: Text('Please fill in all fields before searching.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40 * s.customHeight,
                                      width: 110 * s.customWidth,
                                      decoration: BoxDecoration(color: Color.fromARGB(255, 27, 181, 253), borderRadius: BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text(
                                          "Search",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ).px16()
                                ],
                              ).px8(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isListViewVisible,
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width / 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listOfLocation.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _locationController.text = listOfLocation[index]["description"];
                              _isListViewVisible = false;
                            });
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on_rounded,
                              size: 20,
                            ),
                            title: Text(
                              listOfLocation[index]["description"],
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ).pSymmetric(v: 5),
                          ),
                        );
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 60 * s.customHeight,
            ),
            CarouselSlider(
              items: sliderImages.map((imagePath) {
                return Container(
                  width: s.width / 1.9,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 380 * s.customHeight, // Adjust height as needed
                enableInfiniteScroll: true, // Allows infinite scrolling
                autoPlay: true, // Automatically scroll items
                autoPlayInterval: Duration(seconds: 3), // Set auto-play interval
                autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
                autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                // enlargeCenterPage: true, // Enlarge the centered item
                scrollDirection: Axis.horizontal, // Set scroll direction
              ),
            ),
            SizedBox(
              height: 60 * s.customHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget generatePositionedCircle({
    required double left,
    required double top,
    required double radius,
    required String imagePath,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(offset: Offset(0, 5), spreadRadius: 2, blurRadius: 6, color: Colors.white)
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.blue.shade200,
          radius: radius,
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
