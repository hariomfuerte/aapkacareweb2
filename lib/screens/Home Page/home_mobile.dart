import 'dart:convert';
import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/screens/Result%20Page/Result.dart';
import 'package:flutter/material.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyDEbV8pJrdpVk5sFC0pGaxXyag4IpRoRTA";

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  String test = '';
  String? data;
  String? _selectedExperience;
  bool _isListViewVisible = false;
  int _current = 0;

  TextEditingController _locationController = TextEditingController();
  final CarouselController _controller = CarouselController();

  List<dynamic> listOfLocation = [];

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onChange);
    // fetchDataFromFirebase();
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

  startLaunchURL(String url) async {
    // const url = 'https://flutter.dev';

    var urllaunchable = await canLaunchUrl(Uri.parse(url)); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); //launch is from url_launcher package to launch URL
    } else {
      print("URL can't be launched.");
    }
  }

  List<String> _experiences = [
    'Doctor',
    'Nurse',
    'Hospital',
    'Patient',
  ];

  List<String> sliderImages = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
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
        child: AppBar(
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
            ],
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10 * s.customHeight,
            ),
            CarouselSlider(
              items: sliderImages.map((imagePath) {
                return Container(
                  width: s.width,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                  ),
                ).px(4);
              }).toList(),
              options: CarouselOptions(
                height: s.width / (s.width < 750 ? 2 : 3) * s.customHeight,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              carouselController: _controller,
            ),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderImages.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.blue).withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Theme(
              data: ThemeData(focusColor: Colors.white, splashColor: Colors.transparent),
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
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  hintText: 'What you need',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                // padding: EdgeInsets.only(left: 40),
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ).w(s.width).px(148 * s.customWidth).h(50),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Container(
              height: 50,
              width: s.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 6 * s.customHeight, bottom: 8, left: 10),
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
              ),
            ).px(148 * s.customWidth),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Visibility(
              visible: _isListViewVisible,
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
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
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            ).pSymmetric(v: 5),
                          ),
                        );
                      }),
                ),
              ),
            ).px(148 * s.customWidth),
            SizedBox(
              height: 10 * s.customHeight,
            ),
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
                      duration: Duration(milliseconds: 800),
                      content: Text(
                        'Please fill in all fields before searching.',
                        style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 45 * s.customHeight,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 27, 181, 253),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.search_sharp,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    AutoSizeText(
                      " Search ",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ).px(148 * s.customWidth),
            SizedBox(
              height: 30 * s.customHeight,
            ),
          ],
        ),
      ),
    );
  }
}
